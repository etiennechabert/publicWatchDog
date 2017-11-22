module ModuleInstance::ModuleInstanceDiscover
    extend ActiveSupport::Concern

    REFRESH_RATE_MODULES_TECH_1 = 1
    REFRESH_RATE_MODULES_TECH_2 = 2
    REFRESH_RATE_MODULES_TECH_3 = 3
    REFRESH_RATE_MODULES_TECH_4_5 = 7
    REFRESH_RATE_MODULES_GENERAL = 7
    REFRESH_RATE_IDLE_MODULES = 31

    ATTRIBUTES = ['begin', 'end', 'end_register', 'scolaryear', 'codeinstance', 'instance_location', 'resp']
    TRANSLATE_ATTRIBUTES = {
        'scolaryear' => 'scholar_year',
        'instance_location' => 'location',
        'codeinstance' => 'code',
        'resp' => 'professors'
    }

    module ClassMethods
        def refresh_rates
            [
                REFRESH_RATE_MODULES_GENERAL,
                REFRESH_RATE_MODULES_TECH_1,
                REFRESH_RATE_MODULES_TECH_2,
                REFRESH_RATE_MODULES_TECH_3,
                REFRESH_RATE_MODULES_TECH_4_5
            ]
        end

        def refresh
            epitech_module_instances = refresh_selection
            return false if epitech_module_instances.empty?
            epitech_module_instances.each do |epitech_module_instance|
                epitech_module_instance.discover_details if epitech_module_instance.need_refresh?
                epitech_module_instance.mark_as_refresh # We do this task here because discover_details is async
            end
            true
        end

        def refresh_selection
            self.uncached { self.where('crawler_stamp < ?', Date.today).limit(EpitechDiscover.discover_size_block) }
        end

        def try_create(attributes)
            epitech_module = EpitechModule.try_create(attributes)
            # To avoid error 500 on intra for https://intra.epitech.eu/module/2013/B-ADM-050/LIL-1-1/
            return nil if epitech_module.nil?
            epitech_module_instance = self.find_by(scholar_year: attributes['scolaryear'], epitech_module_id: epitech_module.id, code: attributes['codeinstance'])
            return epitech_module_instance unless epitech_module_instance.nil?
            attributes = {epitech_module_id: epitech_module.id}.merge translate_attributes(attributes)
            puts 'Try create module_instance : ' + attributes.to_json

            begin
                create!(attributes)
            rescue Exception => e
                SerializedException.create({
                                               class_name: 'ModuleInstance:try_create',
                                               exception_message: e.to_s,
                                               serialized_instance: attributes.to_json,
                                               serialized_stack: e.backtrace.to_json
                                           })
            end
        end
    end

    def discover_details
        begin
            parser = EpitechModuleParser.new
            module_details = parser.module_details(self.scholar_year, self.epitech_module.code, self.code)
            if module_details.class == SerializedException
                self.update_attribute(:corrupted, true)
                return
            end
            self.epitech_module.discover_details(module_details[:details])
            attributes = translate_attributes(module_details[:details]).symbolize_keys!
            assign_users(attributes.extract!(:professors))
            update_attributes(attributes)
            discover_students(module_details)
            discover_activities(module_details)
            discover_activities_details
        rescue EpitechRequest::InvalidResponse, EpitechRequest::NotFound => e
            self.update_attribute(:corrupted, true)
        rescue Exception => e
            handleException(self, e)
        end
    end

    def need_refresh?
        return false if self.corrupted # This module as been marked as corrupted due to invalid intra data ... fuck it

        return true if self.students_hash == '' || self.activities_hash == '' # This module hasn't been discovered yet

        return true if self.crawler_stamp < Date.today.days_ago(31) # All instances are discovered at least once a month
        return false if self.crawler_stamp > Date.today.days_ago(1) # This module instance as already been update today

        return false if self.end.present? && Date.today.days_ago(31) > self.end # This instance is finish since at least a month

        true # All the previous conditions are not reach, the default comportment is to refresh
    end

    def redis_keys
        "*/module/#{self.scholar_year}/#{self.epitech_module.code}/#{self.code}/*"
    end

    def discover_activities(module_details)
        return if check_hash(:activities_hash, module_details[:details]['activites'])
        update_hash(:activities_hash, module_details[:details]['activites'])
        ModuleInstanceActivityRelation.update_relations(self, module_details[:details]['activites'])
        ActiveRecord::Base.connection.query_cache.clear
    end

    def discover_activities_details
        self.module_instance_activity_relations.reset.each do |activity_relation| # The reset is used to invalidate the cache
            begin
                activity_relation.discover_details
            rescue EpitechRequest::InvalidResponse # In case of this activity didn t exist anymore
                activity_relation.destroy
            end
        end
        calc_average
    end

    def calc_average
        self.module_instance_student_relations.includes(:grades).each do |registration|
            registration.update_attributes({
                                               average: registration.grades.average(:grade).to_f
                                           })
        end
        self.update_attributes({
                                   min: self.module_instance_student_relations.minimum(:average).to_f,
                                   max: self.module_instance_student_relations.maximum(:average).to_f
                               })

    end

    def discover_students(module_details)
        return if check_hash(:students_hash, module_details[:registered_students])
        update_hash(:students_hash, module_details[:registered_students])

        registered_students = {}
        module_details[:registered_students].each do |e|
            registered_students[e['login']] = e
        end

        students_to_insert = Student.transaction do
            registered_students.keys.map do |student_login|
                Student.try_create('login' => student_login)
            end
        end

        students_to_insert.each do |student|
            if student.class != Student
                SerializedException.create({
                                               class_name: 'Module_instance:discover_students',
                                               exception_message: 'Missmatch in collection',
                                               serialized_instance: student.to_json,
                                               serialized_stack: e.backtrace.to_json
                                           })
            end
        end

        self.students = students_to_insert

        ModuleInstanceStudentRelation.transaction do
            self.module_instance_student_relations.includes(:student).each do |registration|
                registration.refresh(registered_students[registration.student.login])
            end
        end
    end

    handle_asynchronously :discover_details
end
