class ModuleInstanceActivityRelation < ActiveRecord::Base
    include Refreshable
    include TranslateAttributes

    validates :code, presence: true
    validates :module_activity_id, presence: true
    validates :module_instance_id, presence: true

    belongs_to :module_instance
    belongs_to :module_activity
    has_one :epitech_module, through: :module_activity
    has_many :grades, dependent: :destroy
    has_many :groups, class_name: 'InstanceActivityGroup', dependent: :destroy
    has_many :students, through: :groups
    has_many :module_instance_events, foreign_key: 'activity_id'
    has_many :events, class_name: ModuleInstanceEvent, foreign_key: :activity_id

    ATTRIBUTES = ['codeacti', 'begin', 'end', 'is_note', 'is_projet', 'is_blocins']
    TRANSLATE_ATTRIBUTES = {
        'codeacti' => 'code',
        'is_note' => 'is_grades', #note
        'is_projet' => 'is_project', #project
        'is_blocins' => 'is_registration' #rdv
    }

    def self.update_relations(module_instance, activities)
        existing_activities_code = module_instance.module_instance_activity_relations.map{|e| e[:code]}
        activities_code = activities.map{|e| e["codeacti"]}
        to_remove = existing_activities_code - activities_code
        to_insert = activities_code - existing_activities_code
        ModuleInstanceActivityRelation.transaction do
            ModuleInstanceActivityRelation.destroy(module_instance.module_instance_activity_relations.where(code: to_remove).map {|e| e.id}) unless to_remove.empty?
            return if to_insert.empty?
            activities.each do |e|
                next unless to_insert.include?(e["codeacti"])
                ModuleInstanceActivityRelation.try_create(e, module_instance)
            end
        end
    end

    # @param [Hash] attributes
    # @param [ModuleInstance] module_instance
    def self.try_create(attributes, module_instance)
        module_instance_activity = self.find_by_code(attributes['codeacti'])
        return module_instance_activity unless module_instance_activity.nil?
        module_activity = ModuleActivity.try_create(attributes, module_instance.epitech_module)
        return nil if module_activity.nil?
        attributes = {
            module_instance_id: module_instance.id,
            module_activity_id: module_activity.id
        }.merge(translate_attributes(attributes))

        begin
            create!(attributes)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'ModuleInstanceActivityRelation:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attributes.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    def discover_details
        discover_activity
        discover_grades if is_grades
        discover_groups if is_project
        discover_registration if is_registration
        calc_average
    end

    def average_grades
        result = 0.0
        self.grades.each {|grade| result += grade.grade}
        (result / self.grades.size).round(2)
    end

    def missing_students(existing_students)
        module_instance.students - existing_students
    end

    def intra_link
        "https://intra.epitech.eu/module/#{self.module_instance.scholar_year}/#{self.module_instance.epitech_module.code}/#{self.module_instance.code}/#{self.code}"
    end

    def total_days
        (self.end - self.begin).to_i
    end

    def days_done
        [[(Date.today - self.begin).to_i, 0].max, total_days].min
    end

    def days_left
        [[(self.end - Date.today).to_i, 0].max, total_days].min
    end

    def pourcent_left
        ((days_left.to_f / total_days.to_f) * 100).round
    end

    def pourcent_done
        ((days_done.to_f / total_days.to_f) * 100).round
    end

    def project_days
        (self.begin..self.end).to_a
    end

    def netsoul_for_student(student) # This student extract netsoul data from student for timeline of the project
        netsoul_logs = JSON.parse student.logs
        project_days.map do |day|
            day_key = day.to_s
            unless netsoul_logs[day_key]
                {active_at_school: 0, promo_average: 0}
            else
                netsoul_logs[day_key]
            end
        end
    end

    def students_by_grades
        self.grades.includes(:student).map(&:student)
    end

    def students_by_events
        result = []
        self.events.includes(:students).each do |event|
            result += event.students
        end
        result
    end

    private

    def discover_activity
        activity_parser = EpitechActivityParser.new
        activity_details = activity_parser.activity(module_instance.scholar_year, epitech_module.code, module_instance.code, code)
        update_attributes(translate_attributes(activity_details))
        ModuleInstanceEvent.try_create(self, activity_details['events'])
        self.module_instance_events.each do |event|
            event.discover
        end
    end

    def discover_grades
        return unless self.is_grades
        activity_parser = EpitechActivityParser.new
        grades_list = activity_parser.grades_list(module_instance.scholar_year, epitech_module.code, module_instance.code, self.code)

        return if check_hash(:grades_hash, grades_list)

        Grade.update_relations(self, grades_list)
        update_hash(:grades_hash, grades_list)
    end

    def discover_groups
        activity_parser = EpitechActivityParser.new
        groups_list = activity_parser.groups_list(module_instance.scholar_year, epitech_module.code, module_instance.code, self.code)

        return if check_hash(:groups_hash, groups_list)

        InstanceActivityGroup.update_elements(self, groups_list)
        update_hash(:groups_hash, groups_list)
    end

    def calc_average
        return unless self.is_grades
        self.update_attributes({
                                  min: self.grades.minimum(:grade),
                                  max: self.grades.maximum(:grade)
                              })
    end

    def discover_registration
        #implem RDV
    end
end
