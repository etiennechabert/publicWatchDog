class AddIndexOnDateOnGrades < ActiveRecord::Migration
    def change
        add_index :grades, :date
    end
end
