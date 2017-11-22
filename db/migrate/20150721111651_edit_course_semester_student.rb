class EditCourseSemesterStudent < ActiveRecord::Migration
    def change
        remove_column :students, :semester_id
        add_column :students, :course_semester_relation_id, :integer, default: nil
        add_index :students, :course_semester_relation_id
    end
end
