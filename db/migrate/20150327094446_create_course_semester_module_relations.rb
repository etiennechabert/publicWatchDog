class CreateCourseSemesterModuleRelations < ActiveRecord::Migration
    def change
        create_table :course_semester_module_relations do |t|
            t.integer :epitech_module_id, null: false
            t.integer :course_semester_relation_id, null: false

            t.index [:epitech_module_id, :course_semester_relation_id], unique: true, name: 'epitech_module_id_and_course_semester_module_relations'

            t.timestamps null: false
        end
    end
end
