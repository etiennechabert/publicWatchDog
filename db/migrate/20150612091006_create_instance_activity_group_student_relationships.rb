class CreateInstanceActivityGroupStudentRelationships < ActiveRecord::Migration
    def change
        create_table :instance_activity_group_student_relationships do |t|
            t.integer   :instance_activity_group_id, null: false
            t.integer   :student_id, null: false
            t.boolean   :leader, default: false
            t.boolean   :confirmed, default: false
            t.timestamps null: false
        end
    end
end
