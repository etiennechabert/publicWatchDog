class AddScholarYearToCourseSemesterRelation < ActiveRecord::Migration
    def change
        add_column :course_semester_relations, :scholar_year, :integer, null: false
    end
end
