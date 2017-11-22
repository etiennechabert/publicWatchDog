class MigrateAndRemoveFieldFromGroup < ActiveRecord::Migration
    def change
        Group.all.each do |group|
            group.access_level = :assistant if group.allowed
            group.access_level = :admin if group.admin
            group.save
        end

        remove_column :groups, :allowed
        remove_column :groups, :admin
    end
end
