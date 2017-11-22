class CreateGroups < ActiveRecord::Migration
    def change
        create_table :groups do |t|
            t.string :title, null: false
            t.boolean :allowed, default: false
            t.boolean :admin, default: false

            t.index :title, unique: true
        end
    end
end
