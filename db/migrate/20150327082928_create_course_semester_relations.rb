class CreateCourseSemesterRelations < ActiveRecord::Migration
    def change
        create_table :course_semester_relations do |t|
            t.integer :course_id, null: false
            t.integer :semester_id, null: false

            t.index [:course_id, :semester_id], unique: true

            t.timestamps null: false
        end
    end
end
