class EditIndexOnCourseSemesterRelation < ActiveRecord::Migration
    def change
        remove_index :course_semester_relations, [:course_id, :semester_id]
        add_index "course_semester_relations", [:course_id, :semester_id, :scholar_year], name: "index_course_semester_relations_on_course_id_and_semester_id", unique: true
    end
end
