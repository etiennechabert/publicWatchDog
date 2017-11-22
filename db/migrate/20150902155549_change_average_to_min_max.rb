class ChangeAverageToMinMax < ActiveRecord::Migration
  def change
      remove_column :module_instance_activity_relations, :average
      remove_column :module_instances, :average
      remove_column :module_instance_student_relations, :average

      add_column :module_instance_activity_relations, :min, :float
      add_column :module_instances, :min, :float
      add_column :module_instance_student_relations, :min, :float
      add_column :module_instance_activity_relations, :max, :float
      add_column :module_instances, :max, :float
      add_column :module_instance_student_relations, :max, :float
  end
end
