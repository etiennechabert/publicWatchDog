class AddMissingIndex < ActiveRecord::Migration
  def change
      add_index :instance_activity_groups, :module_instance_activity_relation_id, name: 'instance_activity_groups_on_module_instance_activity_relation_id'
      add_index :module_activities, [:epitech_module_id, :title]
      add_index :grades, :module_instance_activity_relation_id
  end
end
