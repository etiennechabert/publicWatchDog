class AddAccessLevelToGroups < ActiveRecord::Migration
    def change
        add_column :groups, :access_level, :integer, default: 0
    end
end
