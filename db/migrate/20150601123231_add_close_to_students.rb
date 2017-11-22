class AddCloseToStudents < ActiveRecord::Migration
    def change
        add_column :students, :close, :text, default: nil
        add_column :students, :close_date, :date, default: nil
    end
end
