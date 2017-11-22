class CourseSemesterRelation < ActiveRecord::Base
    belongs_to :course
    belongs_to :semester
    has_many :course_semester_module_relations
    has_many :epitech_modules, through: :course_semester_module_relations
    has_many :students

    def mandatory_modules
        self.epitech_modules.where('mandatory = 1 OR year_mandatory = 1 OR course_mandatory = 1')
    end
end
