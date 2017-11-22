class CreateModuleInstanceProfessorRelations < ActiveRecord::Migration
    def change
        create_table :module_instance_professor_relations do |t|
            t.integer :module_instance_id
            t.integer :professor_id

            t.index [:module_instance_id, :professor_id], unique: true, name: 'responsable_relations_on_epitech_module_id_and_responsable_id'
        end
    end
end
