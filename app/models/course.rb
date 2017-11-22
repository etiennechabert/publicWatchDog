class Course < ActiveRecord::Base
    has_many :course_semester_relations
    has_many :semesters, through: :course_semester_relations
    has_many :epitech_modules, through: :semesters
    has_many :module_instances, through: :epitech_modules
    has_many :students, through: :semesters
    belongs_to :school

    def self.try_create(name, school_id)
        details = name.split('/')
        course = Course.where(degree: details.first, degree_type: details.second).first
        if course
            course.name = name
            course.save if course.changed?
            return course
        end

        attr = {degree: details.first, degree_type: details.second, name: name, school_id: school_id}

        begin
            create!(attr)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'Course:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attr.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    def self.course_select
        Course.all.order(:school_id).map { |course| [course.name.humanize, course.id] }
    end
end
