class CreateStudentCheckupRelations < ActiveRecord::Migration
  def change
    create_table :student_checkup_relations do |t|
        t.integer :student_id, null: false
        t.integer :user_id, null: false
        t.integer :checkup_id, null: false
        t.string :checkup_type, null: false

        t.index [:student_id, :checkup_id, :user_id, :checkup_type], unique: true, name: 'checkup_relations_on_student_id_and_checkup_id_and_checkup_type'

        t.timestamps null: false
    end
  end
end
