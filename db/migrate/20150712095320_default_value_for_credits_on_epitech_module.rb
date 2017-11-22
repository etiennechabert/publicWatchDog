class DefaultValueForCreditsOnEpitechModule < ActiveRecord::Migration
    def change
        change_column :epitech_modules, :credits, :integer, default: 0
    end
end
