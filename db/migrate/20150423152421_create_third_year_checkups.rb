class CreateThirdYearCheckups < ActiveRecord::Migration
  def change
    create_table :third_year_checkups do |t|
        t.integer :success_chance, null: false

        t.boolean :as_part_time, default: false
        t.boolean :as_internship, default: false

      t.timestamps null: false
    end
  end
end
