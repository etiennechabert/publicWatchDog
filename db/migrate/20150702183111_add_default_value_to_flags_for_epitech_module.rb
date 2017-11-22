class AddDefaultValueToFlagsForEpitechModule < ActiveRecord::Migration
    def change
        change_column :epitech_modules, :flags, :integer, :default => 0
    end
end
