class ModuleInstance < ActiveRecord::Base
    include Refreshable
    include TranslateAttributes
    include ExceptionHandler
    include AssignUsers

    #ModuleInstance parts
    include ModuleInstanceDiscover
    include ModuleInstanceAnalysis

    validates :epitech_module_id, presence: true
    validates :code, presence: true
    validates :scholar_year, presence: true

    has_many :module_instance_activity_relations, dependent: :destroy
    has_many :module_activities, through: :module_instance_activity_relations
    has_many :module_instance_student_relations, dependent: :destroy
    has_many :students, through: :module_instance_student_relations
    belongs_to :epitech_module
    has_one :semester, through: :epitech_module
    has_many :grades, through: :module_instance_activity_relations
    has_many :module_instance_professor_relations
    has_many :professors, through: :module_instance_professor_relations

    def intra_link
        "https://intra.epitech.eu/module/#{self.scholar_year}/#{self.epitech_module.code}/#{self.code}"
    end

    def identifier
        "#{self.epitech_module.code}-#{self.scholar_year}-#{self.code}"
    end

    def projects_definition
        self.module_instance_activity_relations.includes(:module_activity).where(is_grades: true).map {|element| element }.sort_by{|e| e.id}
    end

    def possible_grades
        res = ModuleInstanceStudentRelation.where(:module_instance_id => self.epitech_module.module_instances.map {|e| e.id})
            .select(:grade).distinct.order(grade: 'DESC').map {|e| e.grade}
            .delete_if{|e| e == '-'}
            .join(',')
        "[ordered] #{res}"
    end

    def grade_for_activity_student(activity_relation, student)
        res = activity_relation.grades.find_by_student_id(student.id)
        return 'F' if res.nil?
        return 'F' if res.grade < 2
        return 'GG' if res.grade >= 10
        'G' if res.grade >= 2
    end

    def students_not_registered
        students_registered = self.students.all.map {|student| student.id}
        promotions = self.students.all.select(:promo_id).group(:promo_id).count.select {|k, v| v > 10}.map {|k, v| k}
        s = Student.arel_table
        Student.where(s[:promo_id].in(promotions).and(s[:id].not_in(students_registered)).to_sql)
    end

    private


end
