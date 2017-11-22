class AddSchoolIdToUser < ActiveRecord::Migration
  def change
      add_column :students, :school_id, :integer, default: nil
      remove_column :students, :school
  end
end
