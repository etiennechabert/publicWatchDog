class Student < ActiveRecord::Base
    include StudentsHelper
    include TranslateAttributes
    include Refreshable
    include ExceptionHandler

    #Student parts
    include StudentDiscover
    include StudentDbHelpers
    include StudentNetsoulAnalysis

    validates :login, presence: true
    before_save :update_close_date

    attr_accessor :parsed_logs

    belongs_to :school
    belongs_to :course_semester_relation
    has_one :semester, through: :course_semester_relation
    has_one :course, through: :course_semester_relation
    has_many :student_user_relations
    has_many :users, through: :student_user_relations
    has_many :module_instance_student_relations, dependent: :destroy
    has_many :grades, through: :module_instance_student_relations, dependent: :destroy
    has_many :module_instances, through: :module_instance_student_relations
    has_many :epitech_modules, through: :module_instances
    has_many :student_checkup_relations
    has_many :first_year_checkups, through: :student_checkup_relations, source: 'checkup', source_type: 'FirstYearCheckup'
    has_many :second_year_checkups, through: :student_checkup_relations, source: 'checkup', source_type: 'SecondYearCheckup'
    has_many :third_year_checkups, through: :student_checkup_relations, source: 'checkup', source_type: 'ThirdYearCheckup'
    has_many :tickets
    has_many :instance_activity_group_student_relationships
    has_many :projects, :through => :instance_activity_group_student_relationships
    has_many :groups, :through => :instance_activity_group_student_relationships
    has_many :module_instance_event_student_relations
    has_many :events, through: :module_instance_event_student_relations
end
