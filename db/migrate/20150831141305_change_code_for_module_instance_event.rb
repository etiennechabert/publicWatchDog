class ChangeCodeForModuleInstanceEvent < ActiveRecord::Migration
    def change
        change_column :module_instance_events, :code, :string, null: false
    end
end
