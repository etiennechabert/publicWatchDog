class ModuleInstanceEvent < ActiveRecord::Base
    include Refreshable

    belongs_to :module_instance_activity_relation, foreign_key: 'activity_id', class_name: 'ModuleInstanceActivityRelation'
    has_one :module_instance, through: :module_instance_activity_relation
    has_one :epitech_module, through: :module_instance
    has_one :module_activity, through: :module_instance_activity_relation
    has_many :module_instance_event_student_relations, foreign_key: 'event_id', dependent: :destroy
    has_many :students, through: :module_instance_event_student_relations

    def self.try_create(module_instance_activity_relation, events_data)
        events_data.each do |event_data|
            event = self.find_by(code: event_data['code'])
            event = self.new(code: event_data['code'], module_instance_activity_relation: module_instance_activity_relation) unless event
            event.datetime = event_data['begin']
            event.save if event.changed?
        end
    end

    def discover
        parser = EpitechActivityParser.new
        registered_students = parser.event_registered(self.module_instance.scholar_year, self.epitech_module.code, self.module_instance.code, self.module_instance_activity_relation.code, self.code).each
        return if check_hash(:data_hash, registered_students)
        discover_logic(registered_students)
        update_hash(:data_hash, registered_students)
    end

    private

    def discover_logic(registered_students)
        registered_hash = {}
        registered_students.each do |registered|
            registered_hash[registered['login']] = registered
        end
        discover_remove(registered_hash)
        discover_update(registered_hash)
        discover_insert(registered_hash)
    end

    def discover_remove(registered_hash)
        existing_students = Student.where(login: self.students.pluck(:login) - registered_hash.keys).pluck(:id)
        return if existing_students.empty?
        self.transaction do
            self.module_instance_event_student_relations.where(student: existing_students).each(&:destroy)
        end
    end

    def discover_update(registered_hash)
        self.transaction do
            self.module_instance_event_student_relations.includes(:student).each do |registration|
                data = registered_hash[registration.student.login]
                registration.update_attributes!(present: data['present'] == 'present', absent:  data['present'] == 'absent')
                registered_hash[registration.student.login] = nil
            end
        end
        registered_hash.compact!
    end

    def discover_insert(registered_hash)
        self.transaction do
            registered_hash.values.each do |registration|
                self.module_instance_event_student_relations.create!({
                                                                         student: Student.find_or_create_by!(login: registration['login']),
                                                                         present: registration['present'] == 'present',
                                                                         absent:  registration['present'] == 'absent'
                                                                     })
            end
        end
    end
end
