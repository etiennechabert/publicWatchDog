class AddAverageValuesForGradeAndModule < ActiveRecord::Migration
    def change
        add_column :module_instance_activity_relations, :average, :float, default: 0.0
        add_column :module_instances, :average, :float, default: 0.0
    end
end
