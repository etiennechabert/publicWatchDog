class ModuleInstanceStudentRelation < ActiveRecord::Base
    include TranslateAttributes

    validates :student_id, presence: true
    validates :module_instance_id, presence: true

    belongs_to :student
    belongs_to :module_instance

    has_one :epitech_module, through: :module_instance
    has_many :grades, dependent: :destroy
    has_many :module_activities, through: :grades

    before_save :normalize

    ATTRIBUTES = ['date_ins', 'grade', 'flags', 'credits']
    TRANSLATE_ATTRIBUTES = {
        'date_ins' => 'registration_date'
    }

    def self.update_relations(module_instance, registered_students)
        registered_students_login = registered_students.map {|e| e["login"]}
        existing_students_login = module_instance.students.map{|e| e[:login]}
        to_insert = registered_students_login - existing_students_login
        to_remove = existing_students_login - registered_students_login
        ModuleInstanceStudentRelation.destroy(module_instance.module_instance_student_relations.where(student_id: Student.where(login: to_remove).pluck(:id)).pluck(:id)) unless to_remove.empty?
        return if to_insert.empty?
        registered_students.each do |e|
            next unless to_insert.include?(e["login"])
            ModuleInstanceStudentRelation.try_create(e, module_instance)
        end
    end

    # @param [Hash] attributes
    def self.try_create(attributes, module_instance)
        student = Student.try_create(attributes.slice('login'))
        relationship = self.find_by(student_id: student.id, module_instance_id: module_instance.id)
        return relationship unless relationship.nil?

        attributes = {
            student_id: student.id,
            module_instance_id: module_instance.id
        }.merge(translate_attributes(attributes))

        begin
            create!(attributes)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'ModuleInstanceStudentRelation:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attributes.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    def refresh(attributes)
        self.update_attributes(translate_attributes(attributes))
    end

    def normalize
        self.grade = 'E' if self.grade == 'Echec'
        self.grade.upcase!
    end

    #-- HELPERS SECTION

    def self.existing_grades
        self.all.select(:grade).distinct.order(:grade).map {|e| e.grade}
    end
end
