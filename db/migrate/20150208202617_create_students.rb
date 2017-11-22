class CreateStudents < ActiveRecord::Migration
    def change
        create_table :students do |t|
            t.string :login, null: false
            t.string :name
            t.string :picture
            t.string :school
            t.string :location
            t.integer :promo
            t.integer :credits
            t.integer :semester_id
            t.integer :scholar_year

            t.string :log_time_week_1
            t.string :log_time_week_2
            t.string :log_time_week_3
            t.string :log_time_week_4
            t.string :log_time_month_1
            t.string :log_time_month_2
            t.string :log_time_month_3

            t.float :netsoul_value, default: -1.0
            t.float :grades_value, default: -1.0
            t.float :general_value, default: -1.0

            t.integer :success_chance, default: 0
            t.date :last_checkup_date, default: '0001-01-01'

            t.index :login, unique: true

            t.date :crawler_stamp, default: '0001-01-01'
            t.timestamps null: false
        end
    end
end
