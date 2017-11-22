class AddSemesterShortCodeToEpitechModule < ActiveRecord::Migration
  def change
      add_column :epitech_modules, :semester_code, :string, default: ''
  end
end
