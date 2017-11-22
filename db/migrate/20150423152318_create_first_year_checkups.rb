class CreateFirstYearCheckups < ActiveRecord::Migration
    def change
        create_table :first_year_checkups do |t|
            t.boolean :absent
            t.string :nature
            t.integer :success_chance, null: false
            t.text :comment
            t.text :objectives
            t.date :due_date
            t.text :post_it
            t.boolean :as_intership, default: false

            t.timestamps null: false
        end
    end
end
