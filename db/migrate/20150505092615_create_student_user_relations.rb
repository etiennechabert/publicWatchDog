class CreateStudentUserRelations < ActiveRecord::Migration
    def change
        create_table :student_user_relations do |t|
            t.integer :user_id, null: false
            t.integer :student_id, null: false

            t.index [:user_id, :student_id], unique: true
            t.timestamps null: false
        end
    end
end
