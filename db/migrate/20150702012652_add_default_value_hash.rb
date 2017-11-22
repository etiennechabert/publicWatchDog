class AddDefaultValueHash < ActiveRecord::Migration
  def change
      change_column :instance_activity_groups, :data_hash, :string, {default: ''}
  end
end
