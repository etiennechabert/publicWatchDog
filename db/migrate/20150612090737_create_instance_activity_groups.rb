class CreateInstanceActivityGroups < ActiveRecord::Migration
    def change
        create_table :instance_activity_groups do |t|
            t.integer   :module_instance_activity_relation_id, null: false
            t.string    :data_hash, null: false

            t.timestamps null: false
        end
    end
end
