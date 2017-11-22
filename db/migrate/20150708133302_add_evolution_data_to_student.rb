class AddEvolutionDataToStudent < ActiveRecord::Migration
  def change
      remove_column :students, :grades_value
      remove_column :students, :general_value
      add_column :students, :grades_evolution, :float, default: nil
      add_column :students, :grades_average, :float, default: nil
      add_column :students, :grades_data, :text
  end
end
