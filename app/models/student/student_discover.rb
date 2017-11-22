module Student::StudentDiscover
    extend ActiveSupport::Concern

    ATTRIBUTES = ['login', 'title', 'picture', 'location', 'school_code', 'credits', 'promo', 'semester_code', 'course_code', 'gpa_bachelor', 'gpa_master', 'close', 'ctime', 'id_promo', 'scolaryear']
    TRANSLATE_ATTRIBUTES = {
        'school_code' => 'school',
        'title' => 'name',
        'ctime' => 'close_date',
        'id_promo' => 'promo_id',
        'semester_code' => 'semester',
        'course_code' => 'course',
        'scolaryear' => 'scholar_year'
    }

    def redis_keys
        "*/user/#{self.login}*"
    end

    def discover_details
        begin
            parser = EpitechStudentParser.new(self.login)
            discover_student(parser.user_details)
            discover_netsoul(parser.log_netsoul)
            discover_modules(parser.modules)
            discover_binomes(parser.binomes)
        rescue Exception => e
            handleException(self, e)
        end
    end

    def update_close_date
        return unless close_changed?
        if self.close
            self.close_date = Date.today
        else
            self.close_date = nil
        end
    end

    def discover_student(user)
        attributes = Student.translate_attributes(user.slice(*ATTRIBUTES))
        attributes[:school] = School.find_by_name(attributes['school'])
        attributes[:course_semester_relation] = CourseSemesterRelation.find_by({
                                                                                   semester: Semester.find_by_name(attributes.extract!('semester').values.first),
                                                                                   course: Course.find_by_name(attributes.extract!('course').values.first),
                                                                                   scholar_year: self.scholar_year
                                                                               })
        self.update_attributes(attributes)
    end

    def discover_netsoul(netsoul)
        self.update_attribute(:logs, netsoul.to_json)
    end

    def discover_modules(modules)
        modules.each do |epitech_module|
            ModuleInstance.try_create(epitech_module)
        end
    end

    def discover_binomes(binomes)
        binomes["binomes"].each do |binome|
            Student.try_create(binome)
        end
    end

    def grades_evolution_calc_data(grades)
        return nil if grades.length < 2
        begin_date = grades.first.date
        result = {}

        grades.each do |grade|
            year = grade.module_instance.scholar_year
            unless result[year]
                result[year] = []
                begin_date = grade.date
            end
            result[year].push({
                                  x: (grade.date - begin_date).to_i,
                                  y: grade.grade,
                                  weight: grade.epitech_module.credits > 0 ? grade.epitech_module.credits : 1,
                                  date: grade.date,
                                  name: grade.module_activity.title,
                                  module_name: grade.epitech_module.name
                              })
        end

        result.each do |index, element|
            last_x = -1
            result[index].each_with_index do |grades|
                if last_x == grades[:x]
                    grades[:x] = last_x + 1
                end
                last_x = grades[:x]
            end
            result[index] = nil if element.uniq{|e| e[:x]}.length < 2
        end

        result.compact
    end

    def grades_evolution_calc_computation(data)
        line_fit = LineFit.new
        result = {}
        data.each do |k, v|
            line_fit.setData(v.map {|e| e[:x]}, v.map {|e| e[:y]}, v.map {|e| e[:weight]})
            intercept, slope = line_fit.coefficients
            x_max = v.map{|e| e[:x]}.max
            result[k] = {
                grades_data: {
                    scholar_year: k,
                    intercept_start: {x: 0, y: intercept},
                    intercept_end: {x: x_max, y: intercept + ((x_max) * slope)},
                    evolution: slope,
                    data: v
                },
                grades_average_start: intercept,
                grades_average_end: intercept + (x_max * slope),
                grades_evolution: slope
            }
        end
        grades_evolution_to_database(result)
    end

    def grades_evolution_to_database(result)
        last_scholar_year_data = result[(result.keys.map{|e| e.to_i}).max.to_s]

        self.update_attributes({
                                   grades_data: result.to_json,
                                   grades_average_start: last_scholar_year_data[:grades_average_start],
                                   grades_average_end: last_scholar_year_data[:grades_average_end],
                                   grades_evolution: last_scholar_year_data[:grades_evolution]
                               })
    end

    def grades_evolution_calc(force = false)
        grades = self.grades.where('grades.grade > -100 AND grades.grade < 100').includes(:epitech_module, :module_activity).order(:date)
        result = grades_evolution_calc_data(grades)
        return self.update_attributes(grades_data: '') if result.nil? && force == false
        grades_evolution_calc_computation(result)
    end

    module ClassMethods
        def refresh(students=nil)
            students = self.where(login: students) if students
            students = refresh_selection unless students
            return false if students.blank?
            self.transaction do
                students.each do |student|
                    student.mark_as_refresh
                    student.discover_details
                end
            end
            true
        end

        def after_refresh
            after_refresh_grades_evolution
        end

        def after_refresh_grades_evolution
            Student.where(grades_data: nil).each {|student| student.delay.grades_evolution_calc}
        end

        def try_create(attributes)
            return nil if attributes.has_key?('login') == false || attributes['login'].nil?
            student = self.find_by_login(attributes['login'])
            return student unless student.nil?

            attributes = translate_attributes(attributes)

            begin
                create!(attributes)
            rescue ActiveRecord::RecordNotUnique # Due to race condition this case could append
                sleep(1)
                Student.connection.query_cache.clear
                return try_create(attributes)
            rescue Exception => e
                SerializedException.transaction do # We need to open a new transaction block otherwise this creation is going to be rolled back by exception
                    SerializedException.create({
                                                   class_name: 'Student:try_create',
                                                   exception_message: e.to_s,
                                                   serialized_instance: attributes.to_json,
                                                   serialized_stack: e.backtrace.to_json
                                               })
                end
            end
        end

        def refresh_selection
            self.uncached do
                self.where('crawler_stamp < ?', Date.today).limit(EpitechDiscover.discover_size_block)
            end
        end
    end

    handle_asynchronously :discover_details
end