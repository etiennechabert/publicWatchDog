class CreateEpitechModuleResponsableRelations < ActiveRecord::Migration
    def change
        create_table :epitech_module_responsable_relations do |t|
            t.integer :epitech_module_id
            t.integer :responsable_id

            t.index [:epitech_module_id, :responsable_id], unique: true, name: 'responsable_relations_on_epitech_module_id_and_responsable_id'
        end
    end
end
