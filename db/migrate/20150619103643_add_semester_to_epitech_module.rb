class AddSemesterToEpitechModule < ActiveRecord::Migration
  def change
      add_column :epitech_modules, :semester_id, :integer, default: nil

      remove_column :epitech_modules, :semester_code
  end
end
