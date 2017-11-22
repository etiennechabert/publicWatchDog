class ChangeAverageToMinMaxV2 < ActiveRecord::Migration
    def change
        remove_column :module_instance_student_relations, :min
        remove_column :module_instance_student_relations, :max
        add_column :module_instance_student_relations, :average, :float, :default => 0
    end
end
