class Semester < ActiveRecord::Base
    include TranslateAttributes
    validates :name, presence: true

    belongs_to :parent_semester, class_name: 'Semester', foreign_key: 'parent_semester_id'
    has_many :children_semesters, class_name: 'Semester', foreign_key: 'parent_semester_id'
    has_many :course_semester_relations
    has_many :courses, through: :course_semester_relations
    has_many :course_semester_module_relations, through: :course_semester_relations
    has_many :epitech_modules, through: :course_semester_module_relations
    has_many :module_instances, through: :epitech_modules
    has_many :students, through: :course_semester_relations

    ATTRIBUTES = ['parent_code', 'num', 'code', 'credits_min', 'credits_norm', 'credits_obj', 'nslog_min', 'nslog_norm']
    TRANSLATE_ATTRIBUTES = {
        'num' => 'number',
        'code' => 'name',
        'credits_min' => 'minimal_credits',
        'credits_norm' => 'average_credits',
        'credits_obj' => 'expected_credits',
        'nslog_min' => 'minimal_log_time',
        'nslog_norm' => 'expected_log_time'
    }

    def self.try_create(attributes)
        attributes = establish_relation(translate_attributes(attributes))
        semester = self.find_by_name(attributes['name'])
        return semester unless semester.nil?
        puts 'Try create semester : ' + attributes.to_json
        attributes[:scholar_year] = (attributes['number'].to_i / 2) + (attributes['number'].to_i % 2)

        begin
            create!(attributes)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'Semester:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attributes.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    def self.update_details(semesters_list, scholar_year, courses_school)
        tmp_schools_hash = {}
        schools_hash = {}
        School.all.each { |school| tmp_schools_hash.merge! school.name => school.id }
        courses_school.each do |attributes|
            schools_hash[attributes[0]] = tmp_schools_hash[attributes[1]]
        end

        semesters_list.each do | semester_attributes |
            update_details_element(schools_hash, scholar_year, semester_attributes)
        end
    end

    def self.update_details_element(schools_hash, scholar_year, semester_attributes)
        school_id = schools_hash.each do |school_hash|
            break school_hash[1] if semester_attributes['course_code'].include?(school_hash[0])
        end
        semester = Semester.find_by_name(semester_attributes['semester_code'])
        course = Course.try_create(semester_attributes['course_code'], school_id)
        relation = CourseSemesterRelation.find_or_create_by(course: course, semester: semester, scholar_year: scholar_year)
        epitech_modules = semester_attributes["modules"].tr(' ', '').split(',').uniq.map {|module_code| EpitechModule.try_create({'codemodule' =>module_code})}
        relation.update_attribute(:epitech_modules, epitech_modules)
    end

    private

    def self.establish_relation(attributes)
        attributes[:parent_semester] = Semester.find_by_name(attributes.extract!('parent_code').values.first)
        attributes['name'] = build_name(attributes)
        attributes
    end

    def self.build_name(attributes)
        return "#{attributes[:parent_semester][:name]}/#{attributes['name']}" unless attributes[:parent_semester].nil?
        attributes['name']
    end
end
