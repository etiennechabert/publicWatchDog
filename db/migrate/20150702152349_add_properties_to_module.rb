class AddPropertiesToModule < ActiveRecord::Migration
  def change
      add_column :epitech_modules, :optional, :boolean, default: false
      add_column :epitech_modules, :progressive, :boolean, default: false
      add_column :epitech_modules, :course_mandatory, :boolean, default: false
      add_column :epitech_modules, :year_mandatory, :boolean, default: false
      add_column :epitech_modules, :multiple_registration, :boolean, default: false
      add_column :epitech_modules, :hide_on_resume, :boolean, default: false
      add_column :epitech_modules, :mandatory, :boolean, default: false
      add_column :epitech_modules, :security, :boolean, default: false
  end
end
