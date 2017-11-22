class AddDescriptionToModule < ActiveRecord::Migration
  def change
      add_column :epitech_modules, :description, :text
  end
end
