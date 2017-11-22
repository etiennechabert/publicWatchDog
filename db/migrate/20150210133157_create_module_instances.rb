class CreateModuleInstances < ActiveRecord::Migration
    def change
        create_table :module_instances do |t|
            t.integer :epitech_module_id, null: false
            t.string :code, null: false
            t.string :scholar_year, null: false
            t.string :location
            t.date :begin
            t.date :end
            t.date :end_register

            t.date :crawler_stamp, default: '0001-01-01'
            t.boolean :corrupted, default: false

            t.string :activities_hash, limit: 32, default: ''
            t.string :students_hash, limit:32, default: ''

            t.index [:epitech_module_id, :code, :scholar_year], unique: true, name: 'module_instances_on_epitech_module_id_and_code_and_scholar_year'

            t.timestamps null: false
        end
    end
end
