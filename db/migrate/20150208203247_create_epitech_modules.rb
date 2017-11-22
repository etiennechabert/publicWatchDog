class CreateEpitechModules < ActiveRecord::Migration
    def change
        create_table :epitech_modules do |t|
            t.string :name
            t.string :code, null: false
            t.integer :flags
            t.integer :credits

            t.index :code, unique: true

            t.timestamps null: false
        end
    end
end
