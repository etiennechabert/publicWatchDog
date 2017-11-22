class Grade < ActiveRecord::Base
    include Refreshable
    include TranslateAttributes

    validates :module_instance_student_relation_id, presence: true
    validates :module_instance_activity_relation_id, presence: true

    # noinspection RailsParamDefResolve
    belongs_to :corrector, class_name: 'Student', foreign_key: 'corrector_id'
    belongs_to :module_instance_student_relation
    belongs_to :module_instance_activity_relation
    has_one :student, through: :module_instance_student_relation
    has_one :module_activity, through: :module_instance_activity_relation
    has_one :module_instance, through: :module_instance_activity_relation
    has_one :epitech_module, through: :module_instance

    after_save :clear_grade_evolution

    ATTRIBUTES = ['note', 'comment', 'date', 'student_id', 'corrector_id']
    TRANSLATE_ATTRIBUTES = {
        'note' => 'grade',
    }

    def self.update_relations_list(module_instance_activity, grades_list)
        existing_grades_students = module_instance_activity.grades.includes(:student).map do |e|
            unless e.student
                e.destroy
                nil
            else
                e.student.login
            end
            ##### READ ME : THIS IS A SHITY FIX DUE TO LACK OF DATABASE CONSISTENCY. FOR SOME REASON A GRADE MAY
            ##### NOT BE LINKED WITH A MODULE_INSTANCE_STUDENT_RELATION !
        end
        existing_grades_students.compact!

        grades_list_login = grades_list.map{|grade| grade["login"]}
        to_remove = existing_grades_students - grades_list_login
        to_add = grades_list_login - existing_grades_students
        to_update = existing_grades_students - (to_remove + to_add)
        {to_add: to_add, to_remove: to_remove, to_update: to_update}
    end

    def self.update_relations_destroy(module_instance_activity, to_remove)
        students_hash = {}
        Student.where(login: actions_list[:to_remove]).each do |student|
            students_hash[student[:login]] = student[:id]
        end

        to_remove_ids = to_remove.map { |student| students_hash[student] }
        module_instance_activity.grades.where(student_id: to_remove_ids).destroy
    end

    def self.update_relations_create(module_instance_activity, to_add, grades_list)
        grades_list.each do |grade|
            next unless to_add.include?(grade["login"])
            try_create(grade, module_instance_activity)
        end
    end

    def self.update_relations_refresh(module_instance_activity, to_update, grades_list)
        students_hash = {}
        Student.where(login: to_update).each do |student|
            students_hash[student[:login]] = student[:id]
        end

        grades_hash = {}
        grades_list.each do |grade|
            grades_hash[grade["login"]] = grade
        end

        module_instance_activity.grades.where(student_id: Student.where(login: to_update).map {|student| student.id}) do |grade|
            grade_hash = grades_hash[grade[:student_id]]
            next if grade.check_hash(:data_hash, grade_hash)
            grade.destroy
            try_create(grade_hash, module_instance_activity)
        end
    end

    def self.update_relations(module_instance_activity, grades_list)
        actions_list = self.update_relations_list(module_instance_activity, grades_list)

        self.transaction do
            self.update_relations_destroy(module_instance_activity, actions_list[:to_remove]) unless actions_list[:to_remove].empty?
            self.update_relations_create(module_instance_activity, actions_list[:to_add], grades_list) unless actions_list[:to_add].empty?
            self.update_relations_refresh(module_instance_activity, actions_list[:to_update], grades_list) unless actions_list[:to_update].empty?
        end
     end

    # @param [Hash] grade_details
    # @param [ModuleInstanceActivityRelation] module_instance_activity
    def self.try_create(grade_details, module_instance_activity)
        student = Student.try_create('login' => grade_details['login'])
        corrector = Student.try_create('login' => grade_details['grader'])

        # This protection is due to the fact that student my not be registered to a module and still have grade of it
        module_instance_student_relation = ModuleInstanceStudentRelation.find_by(student: student, module_instance: module_instance_activity.module_instance)
        return unless module_instance_student_relation

        attributes = {
            module_instance_activity_relation: module_instance_activity,
            module_instance_student_relation: module_instance_student_relation,
            corrector: corrector
        }.merge(translate_attributes(grade_details))

        attributes[:data_hash] = Digest::MD5.hexdigest(grade_details.to_s)

        begin
            create!(attributes)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'Grade:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attributes.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    private

    def clear_grade_evolution
        self.student.update_attributes({
                                           grades_data: nil,
                                           grades_average_start: nil,
                                           grades_average_end: nil,
                                           grades_evolution: nil
                                       })
    end

end
