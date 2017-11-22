class CreateSecondYearCheckups < ActiveRecord::Migration
  def change
    create_table :second_year_checkups do |t|
        t.integer :success_chance, null: false
        t.boolean :as_hub_project, default: false

        t.timestamps null: false
    end
  end
end
