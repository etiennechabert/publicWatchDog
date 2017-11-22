class CreateGrades < ActiveRecord::Migration
    def change
        create_table :grades do |t|
            t.float :grade, null: false
            t.text :comment
            t.date :date

            t.integer :student_id, null: false
            t.integer :module_instance_activity_relation_id, null: false
            t.integer :corrector_id

            t.index [:student_id, :module_instance_activity_relation_id], unique: true, name: 'grades_on_student_id_and_module_instance_activity_relation_id'
            t.index :corrector_id

            t.string :data_hash, limit:32, default: ''

            t.timestamps null: false
        end
    end
end
