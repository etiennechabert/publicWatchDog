class CreateModuleInstanceEventStudentRelations < ActiveRecord::Migration
    def change
        create_table    :module_instance_event_student_relations do |t|
            t.integer   :event_id, null: false
            t.integer   :student_id, null: false
            t.boolean   :present, default: false
            t.boolean   :absent, default: false

            t.index     [:event_id, :student_id], unique: true, name: 'module_instance_event_student_relations_on_event_id_and_student'
            t.timestamps null: false
        end
    end
end
