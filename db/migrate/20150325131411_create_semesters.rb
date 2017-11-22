class CreateSemesters < ActiveRecord::Migration
    def change
        create_table :semesters do |t|
            t.string :name, null: false
            t.integer :number

            t.integer :minimal_credits
            t.integer :average_credits
            t.integer :expected_credits

            t.integer :minimal_log_time
            t.integer :expected_log_time

            t.integer :parent_semester_id

            t.timestamps null: false

            t.index :name, unique: true
        end
    end
end

