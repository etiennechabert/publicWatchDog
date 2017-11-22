class AddDefaultValueToGradeForModuleInstanceStudentRelationship < ActiveRecord::Migration
    def change
        change_column :module_instance_student_relations, :grade, :string, default: '-'
    end
end
