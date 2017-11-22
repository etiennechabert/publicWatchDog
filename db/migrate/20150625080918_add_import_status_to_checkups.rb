class AddImportStatusToCheckups < ActiveRecord::Migration
  def change
      add_column :first_year_checkups, :imported, :boolean, default: false
      add_column :second_year_checkups, :imported, :boolean, default: false
      add_column :third_year_checkups, :imported, :boolean, default: false
  end
end
