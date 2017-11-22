class ChangeOnRelationForGrade < ActiveRecord::Migration
  def change
      ChangeOnRelationForGrade.transaction do
          remove_index :grades, column: [:student_id, :module_instance_activity_relation_id], name: 'grades_on_student_id_and_module_instance_activity_relation_id'
          remove_column :grades, :student_id

          add_column :grades, :module_instance_student_relation_id, :integer
          add_index :grades, [:module_instance_student_relation_id, :module_instance_activity_relation_id], name: 'module_instance_student_relation_and_module_instance_activity'
      end
  end
end
