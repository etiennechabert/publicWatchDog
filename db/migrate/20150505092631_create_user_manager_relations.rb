class CreateUserManagerRelations < ActiveRecord::Migration
    def change
        create_table :user_manager_relations do |t|
            t.integer :manager_id, null: false
            t.integer :user_id, null: false

            t.index [:manager_id, :user_id], unique: true
            t.timestamps null: false
        end
    end
end
