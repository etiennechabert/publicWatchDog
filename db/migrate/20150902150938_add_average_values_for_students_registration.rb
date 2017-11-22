class AddAverageValuesForStudentsRegistration < ActiveRecord::Migration
    def change
        add_column :module_instance_student_relations, :average, :float, default: 0.0
    end
end
