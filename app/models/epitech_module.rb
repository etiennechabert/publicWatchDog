class EpitechModule < ActiveRecord::Base
    include Refreshable
    include TranslateAttributes
    include AssignUsers

    validates :code, presence: true

    has_many :module_instances, dependent: :destroy
    has_many :module_activities, dependent: :destroy
    has_many :course_semester_module_relations
    has_many :courses, through: :course_semester_module_relations
    has_many :semesters, through: :course_semester_module_relations
    belongs_to :semester
    has_many :schools, through: :course_semester_module_relations
    has_many :epitech_module_responsable_relations
    has_many :responsables, through: :epitech_module_responsable_relations

    ATTRIBUTES = ['title', 'codemodule', 'credits', 'flags', 'description', 'template_resp']
    TRANSLATE_ATTRIBUTES = {
        'codemodule' => 'code',
        'title' => 'name',
        'template_resp' => 'responsables'
    }
    PROPERTY_DEFINITION = [:optional, :progressive, :course_mandatory, :year_mandatory, :nothing, :multiple_registration, :hidden_on_resume, :mandatory, :security]

    def self.semester_code_regex(name)
        name = /[A-Z][0-9] -|[A-Z] -/.match(name).to_s
        name = /[A-Z][0-9]|[A-Z]/.match(name).to_s if name
        name
    end

    def self.update_semester_for_modules
        EpitechModule.all.each do |epitech_module|
            epitech_module.semester = Semester.find_by_name(semester_code_regex(epitech_module.name))
            epitech_module.save if epitech_module.changed?
        end
    end

    # @param [Hash] attributes
    def self.try_create(attributes)
        attributes = translate_attributes(attributes).symbolize_keys!
        # To avoid error 500 on intra for https://intra.epitech.eu/module/2013/B-ADM-050/LIL-1-1/
        return nil if attributes[:code].blank?
        EpitechModule.find_or_create_by(code: attributes[:code])
    end

    def discover_details(attributes)
        attributes = translate_attributes(attributes).symbolize_keys!
        assign_users(attributes.extract!(:responsables))
        assign_attributes(attributes)
        return self unless self.changed?
        self.discover_properties
        self.semester = Semester.find_by_name(self.class.semester_code_regex(self.name))
        self.save! if self.changed?
    end

    def self.semesters_list
        self.uncached do
            self.where('semester >= 0').select(:semester).distinct.order('semester').map do |epitech_module|
                epitech_module.semester
            end
        end
    end

    def semester_code
        return nil unless self.semester
        self.semester.name
    end

    def get_instances_stats
        scholar_year = module_instances.select(:id, :scholar_year).order(scholar_year: 'DESC').distinct.each do |instance|
            if instance.module_instance_student_relations.where.not(grade: '-').count > 0
                break instance.scholar_year
            end
        end

        results = module_instances.where(scholar_year: scholar_year).map {|instance|
            instance.module_instance_student_relations.where.not(grade: '-').group(:grade).count
        }.reject {|e| e.empty? }

        results.map{|instance_stats| instance_stats.merge!(average: calc_average(instance_stats.clone)) }

        return {} if results.empty?

        res = {
            min: results.min {|a,b| a[:average] <=> b[:average]},
            max: results.max {|a,b| a[:average] <=> b[:average]},
            avg: (results.sum {|a| a[:average] } / results.size)
        }

        "#{res[:avg]} (#{res[:min][:average]}-#{res[:max][:average]})"
    end

    def calc_average(instance_stats)
        result = 0
        total = 0
        instance_stats.each do |key, value|
            case key
                when 'A'..'E'
                    result += value * (69 - key.ord)
                when 'ACQUIS'
                    result += value
            end
            total += value
        end
        (result / total).round(2)
    end

    #-- HELPERS SECTION

    def cities
        self.module_instances.select(:location).order(:location).distinct.map { |e| e.location}
    end

    def years
        self.module_instances.select(:scholar_year).order(:scholar_year).distinct.map { |e| e.scholar_year }
    end

    def projects
        module_instance_ids = self.module_instances.select(:id).map {|e| e.id }
        ModuleInstanceActivityRelation.where(is_grades: true, module_instance_id: module_instance_ids).includes(:module_activity).map {
            |e| e.module_activity.slice(:id, :activity_title)
        }.uniq {
            |e| e[:activity_title]
        }
    end

    def discover_properties
        definition = PROPERTY_DEFINITION
        flags.to_s(2).reverse.split('').each_with_index do |element, index|
            next if definition[index] == :nothing
            self[definition[index]] = element == '1'
        end
    end
end
