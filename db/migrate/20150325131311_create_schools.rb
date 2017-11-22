class CreateSchools < ActiveRecord::Migration
    def change
        create_table :schools do |t|
            t.string :name, null: false
            t.string :short_name, null: false
            t.integer :nb_year, null: false
            t.integer :nb_semester, null: false

            t.timestamps null: false

            t.index :name, unique: true
        end
    end
end
