class AddGpaToStudent < ActiveRecord::Migration
  def change
      add_column :students, :gpa_bachelor, :float, default: nil
      add_column :students, :gpa_master, :float, default: nil
  end
end
