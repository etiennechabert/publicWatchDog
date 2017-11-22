class AddScholarYearToSemester < ActiveRecord::Migration
  def change
      add_column :semesters, :scholar_year, :integer, null: false
  end
end
