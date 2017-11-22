class AddDataHashToModuleInstanceEvent < ActiveRecord::Migration
    def change
        add_column :module_instance_events, :data_hash, :string, default: '', limit: 32
    end
end
