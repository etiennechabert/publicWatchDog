class CreateGroupUserRelations < ActiveRecord::Migration
    def change
        create_table :group_user_relations do |t|
            t.integer :user_id, null: false
            t.integer :group_id, null: false

            t.index [:user_id, :group_id], unique: true
        end
    end
end
