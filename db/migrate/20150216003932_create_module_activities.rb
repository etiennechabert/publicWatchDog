class CreateModuleActivities < ActiveRecord::Migration
    def change
        create_table :module_activities do |t|
            t.string :title # null: false FIXME: TMP comment to find all activities without title
            t.string :activity_title, null: false
            t.string :activity_code, null: false
            t.text :description

            t.integer :epitech_module_id, null: false

            # t.index [:title, :epitech_module_id], unique: true, name: 'module_activities_on_title_and_epitech_module_activities'

            t.timestamps null: false
        end
    end
end
