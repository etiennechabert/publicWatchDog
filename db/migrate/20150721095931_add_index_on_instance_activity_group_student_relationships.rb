class AddIndexOnInstanceActivityGroupStudentRelationships < ActiveRecord::Migration
    def change
        add_index :instance_activity_group_student_relationships, [:instance_activity_group_id, :student_id], name: 'student_relationships_on_instance_activity_group_and_student'
    end
end
