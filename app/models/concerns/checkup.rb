module Checkup
    extend ActiveSupport::Concern

    included do
        has_one :student_checkup_relation, as: :checkup, dependent: :delete
        has_one :student, through: :student_checkup_relation
        has_one :user, through: :student_checkup_relation

        validates :student_login, presence: true
        validates :user_login, presence: true

        attr_accessor :student_login, :user_login

        after_save :link_elements
    end

    def update_student
        student = self.student
        last_checkup = student.last_checkup
        success_chance =  last_checkup ? last_checkup.success_chance : 0
        last_checkup_date = last_checkup ? last_checkup.created_at : '0001-01-01'
        student.update_attributes(success_chance: success_chance, last_checkup_date: last_checkup_date)
    end

    def link_elements
        student = Student.find_by_login(student_login)
        #todo : FIX ME WHY THE FUCK ?
        user = User.find_by_login(user_login)
        return StudentCheckupRelation.create({student: student, user: user, checkup: self}) if user && student
        self.destroy
    end

    def date
        "#{self.created_at.strftime('%A %d %B %Y')} (#{self.created_at.strftime('%d/%m/%y')})"
    end

    def time_ago
        ((Time.zone.now - self.created_at) / 1.day).to_i
    end

    def title
        title = self.date + " - " + "#{self.success_chance}%"
        if self.absent
            title += " - Absent"
        end
        "#{title} - by #{self.user.login}"
    end

    def done_by_user(user)
        self.user == user
    end
end