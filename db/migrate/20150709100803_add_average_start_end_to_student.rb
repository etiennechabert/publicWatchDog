class AddAverageStartEndToStudent < ActiveRecord::Migration
  def change
      rename_column :students, :grades_average, :grades_average_start
      add_column :students, :grades_average_end, :float, default: nil
  end
end
