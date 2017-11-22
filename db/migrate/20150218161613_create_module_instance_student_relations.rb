class CreateModuleInstanceStudentRelations < ActiveRecord::Migration
  def change
    create_table :module_instance_student_relations do |t|
        t.integer :module_instance_id, null: false
        t.integer :student_id, null: false
        t.date :registration_date, null: false
        t.integer :credits
        t.integer :flags
        t.string :grade

        t.index [:module_instance_id, :student_id], unique: true, name: 'instance_student_relations_on_module_instance_id_and_student_id'

        t.timestamps null: false
    end
  end
end
