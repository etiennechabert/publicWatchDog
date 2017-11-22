require 'bcrypt'

class User < ActiveRecord::Base
    include TranslateAttributes
    include BCrypt
    devise :remote_authenticatable, :trackable

    include ActiveModel::Validations #required because some before_validations are defined in devise
    extend ActiveModel::Callbacks #required to define callbacks
    extend Devise::Models

    define_model_callbacks :validation #required by Devise

    attr_accessor :password

    has_many :student_user_relations
    has_many :students, through: :student_user_relations
    has_many :tickets_created, class: 'tickets', foreign_key: 'user_id'
    has_many :ticket_assignations
    has_many :tickets, through: :ticket_assignations
    has_many :group_user_relations, dependent: :destroy
    has_many :groups, through: :group_user_relations

    after_create :store_epitech_groups

    def store_epitech_groups
        parser = EpitechStudentParser.new(self.login)
        groups = parser.user_details['groups'].map {|e| e.humanize}

        self.group_user_relations.includes(:group).each do |group_relation|
            next if group_relation.group.title == 'Admin'
            group_relation.destroy unless groups.include?(group_relation.group.title)
        end

        groups.each do |group|
            next if self.groups.find_by_title(group)
            self.groups << Group.find_or_create_by({title: group.humanize})
        end
    end

    def get_access_level
        group = self.groups.order(access_level: :desc).first
        return 0 unless group
        group.access_level
    end

    def check_allowed(required_level = nil)
        required_value = 1
        required_value = Group.access_levels[required_level.to_s] if required_level
        Group.access_levels[get_access_level] >= required_value
    end

    def check_admin
        self.groups.where(admin: true).limit(1).count > 0
    end

    def picture
        "https://cdn.local.epitech.eu/userprofil/profilview/#{self.login}.jpg"
    end

    def password
        @password ||= Password.new(encrypted_password)
    end

    def password=(new_password)
        self.encrypted_password = Password.create(new_password)
    end

    def check_password(check_password)
        self.encrypted_password == Password.create(check_password)
    end

    def ==(user)
        self.login == user.login
    end

    def students_last_chance
        result = {}
        (0..10).to_a.each {|e| result[e*10] = 0}
        self.students.group(:success_chance).count.each do |k, v|
            result[k] = v
        end
        result
    end

    def open_tickets
        self.tickets.where(status: Ticket::OPEN_TICKET)
    end

    def close_tickets
        self.tickets.where(status: Ticket::CLOSE_TICKET)
    end

    def students_last_checkup_date
        results = {today: 0, this_week: 0, two_weeks: 0, this_month: 0, older: 0}
        ref = {
            Date.today.days_ago(1) => :today,
            Date.today.days_ago(7) => :this_week,
            Date.today.days_ago(14) => :two_weeks,
            Date.today.days_ago(31) => :this_month,
            out: :older ## Default case
        }

        self.students.group(:last_checkup_date).count.each do |k, v|
            ref.each do |ref_date, key|
                if !k
                    results[:older] += v
                    break
                elsif ref_date == :out || k > ref_date
                    results[key] += v
                    break
                end
            end
        end
        results
    end

    def students_checkup_range(range_key)
        days_tab = {
            today: {start: nil, end: 1},
            this_week: {start: 1, end: 7},
            two_weeks: {start: 7, end: 14},
            this_month: {start: 14, end: 31},
            older: {start: 31, end: nil}
        }

        day_values = days_tab[range_key]
        students = self.students
        day_values.each do |k, v|
            if k == :start && v
                students = students.where('last_checkup_date <= ?', Date.today.days_ago(v)).includes(:student_checkup_relations)
            elsif k == :end && v
                students = students.where('last_checkup_date > ?', Date.today.days_ago(v)).includes(:student_checkup_relations)
            end
        end
        return day_values, students
    end

    def students_last_checkups
        where_condition = StudentCheckupRelation.where(student: self.students).group(:student_id).maximum(:id)
        StudentCheckupRelation.where(student_id: where_condition.keys, id: where_condition.values).includes(:checkup, :student, :user)
    end

    def students_evolution
        result = {}
        self.students.each do |student|
            result[student.login] = student.get_grades_data
        end
        result
    end

    def students_netsoul
        result = {
            three_months_weekly: {
                labels: (1..12).to_a.reverse.map {|e| (e.week.ago - 1.day).to_date.to_s},
                data: {}
            },
            one_month_weekly: {
                labels: (1..4).to_a.reverse.map {|e| (e.week.ago - 1.day).to_date.to_s},
                data: {}
            },
            one_month_daily: {
                labels: (1..31).to_a.reverse.map {|e| (e.day.ago - 1.day).to_date.to_s},
                data: {}
            }
        }

        self.students.each do |student|
            result[:three_months_weekly][:data][student.login] = (1..12).to_a.reverse.map {|e| student.logs_sum_for_period(e.weeks.ago - 1.day, (e - 1).weeks.ago - 1.day)}
            result[:one_month_weekly][:data][student.login] = (1..4).to_a.reverse.map {|e| student.logs_sum_for_period(e.weeks.ago - 1.day, (e - 1).weeks.ago - 1.day)}
            result[:one_month_daily][:data][student.login] = student.logs_for_period(31.day.ago - 1.day, 1.day.ago)
        end
        result
    end

    def students_search(params)
        students = Student.order(:login).where.not(id: self.students.select(:id).map {|s| s.id})
        course_semester_relations = CourseSemesterRelation.all
        params[:students].each do |k, v|
            next if v.blank?
            case k
                when 'course'
                    course_semester_relations = course_semester_relations.where(course_id: v)
                when 'semester'
                    course_semester_relations = course_semester_relations.where(semester_id: v)
                when 'login_start'
                    students = students.where('login >= ?', v)
                when 'login_end'
                    students = students.where('login <= ?', v)
                else
                    students = students.where(k => v)
            end
        end
        students.where(course_semester_relation_id: course_semester_relations.map {|course_semester_relation| course_semester_relation.id})
    end

    def student_followed?(student)
        self.students.find_by(login: student.login).present?
    end

    private
end
