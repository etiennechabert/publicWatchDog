class CreateModuleInstanceActivityRelations < ActiveRecord::Migration
    def change
        create_table :module_instance_activity_relations do |t|
            t.string :code, null: false
            t.date :begin
            t.date :end
            t.boolean :as_grades

            t.integer :module_activity_id, null: false
            t.integer :module_instance_id, null: false

            t.string :grades_hash, limit:32, default: ''
            t.string :groups_hash, limit:32, default: ''

            t.index :code, unique: true
            t.index :module_activity_id
            t.index :module_instance_id

            t.timestamps null: false
        end
    end
end
