class InstanceActivityGroup < ActiveRecord::Base
    include Refreshable
    include TranslateAttributes

    belongs_to :project, class_name: 'ModuleInstanceActivityRelation', foreign_key: 'module_instance_activity_relation_id'
    has_many :instance_activity_group_student_relationships
    has_many :members, -> {where instance_activity_group_student_relationships: {leader: false}}, through: :instance_activity_group_student_relationships, source: :student
    has_many :leader, -> {where instance_activity_group_student_relationships: {leader: true}}, through: :instance_activity_group_student_relationships, source: :student
    has_many :students, through: :instance_activity_group_student_relationships, source: :student

    def self.update_elements(project, groups_list)
        self.transaction do
            extract_unregistered(project, groups_list[:not_registered])
            update_elements_data(project, groups_list[:registered])
        end
    end

    def average_gpa
        gpa_array = students.map(&:get_gpa)
        gpa_array.sum / gpa_array.size.to_f
    end

    def average_grades
        grades_average_array = students.map do |s|
            grades = s.grades.where('grades.grade < 100').order(date: 'desc').limit(10).map(&:grade)
            grades.sum / grades.size.to_f
        end
        grades_average_array.sum / grades_average_array.size.to_f
    end

    def average_nestsoul
        netsoul_array = (students.map do |s|
            (project.netsoul_for_student(s).map do |n|
                n['active_at_school']
            end).compact.sum
        end)
        netsoul_array.sum / netsoul_array.size.to_f
    end

    def lowest_nestsoul
        (students.map do |s|
            (project.netsoul_for_student(s).map do |n|
                n['active_at_school']
            end).compact.sum
        end).min
    end

    def lowest_grades
        grades_average_array = students.map do |s|
            grades = s.grades.where('grades.grade < 100').order(date: 'desc').limit(10).map(&:grade)
            grades.sum / grades.size.to_f
        end
        grades_average_array.min
    end

    def lowest_gpa
        students.map(&:get_gpa).min
    end

    private

    def self.extract_unregistered(project, unregistered)
        unregistered_students = Student.where(login: unregistered.map {|unregistered_student| unregistered_student["login"]})
        groups = project.groups
        InstanceActivityGroupStudentRelationship.where(group: groups.map{|e| e.id}, student: unregistered_students.map {|e| e.id}).each do |e|
            group = e.group
            e.destroy
            group.destroy unless group.students.count
        end
    end

    def self.update_elements_data(project, registered_groups)
        existing_groups = project.groups
        registered_groups.each do |registered_group|
            group = self.find_by_id(registered_group["id"])
            group = self.new({id: registered_group["id"], project: project}) unless group
            unless group.check_hash(:data_hash, registered_group)
                group.save
                create_student_relation(group, existing_groups, registered_group["master"], true)
                registered_group["members"].each do |member|
                    create_student_relation(group, existing_groups, member)
                end
                group.update_hash(:data_hash, registered_group)
            end
        end
    end

    # @param [InstanceActivityGroup] group
    def self.create_student_relation(group, existing_groups, element, leader=false)
        return unless element
        student = Student.find_or_create_by({login: element["login"]})
        student_relation = InstanceActivityGroupStudentRelationship.find_by(student: student, group: existing_groups.map{|e| e.id})
        student_relation = InstanceActivityGroupStudentRelationship.new(group: group, student: student) unless student_relation
        student_relation.instance_activity_group_id = group.id
        student_relation.confirmed = element['status'] == 'confirmed'
        student_relation.leader = leader
        student_relation.save if student_relation.changed? || student_relation.id.blank?
    end
end
