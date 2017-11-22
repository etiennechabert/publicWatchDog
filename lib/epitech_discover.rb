require 'epitech_module_parser'
require 'epitech_student_parser'

WAITING_TIME = 2
MAX_TASK = 128

class EpitechDiscover
    @@previous_tasks = 0
    @@previous_time = 0
    @@previous_results = []

    class << self
        def discover_size_block
            128
        end

        def discover
            discover_school
            discover_semesters
            discover_instances
            discover_students
            discover_users
        end

        def discover_school
            school_parser = SchoolParser.new
            school_parser.schools_list.each do | school |
                School.try_create(school)
            end
        end

        def discover_semesters
            wait_end_tasks
            semester_parser = SemesterParser.new
            semester_parser.semesters_list[:parents].each do | semester |
                Semester.try_create(semester)
            end
            semester_parser.semesters_list[:childrens].each do | semester |
                Semester.try_create(semester)
            end
            (ModuleInstance.select(:scholar_year).distinct.pluck(:scholar_year) | ['2010', '2011', '2012', '2013', '2014', '2015']).each do |scholar_year|
                Semester.delay.update_details(semester_parser.semesters_modules_list(scholar_year), scholar_year, semester_parser.courses_school)
            end
        end

        def discover_instances
            wait_end_tasks
            epitech_module_parser = EpitechModuleParser.new
            ModuleInstance.transaction do
                epitech_module_parser.modules_list.each do |module_instance|
                    ModuleInstance.try_create(module_instance)
                end
            end
        end

        def discover_loop_sleep?
            Delayed::Job.uncached do
                return true if Delayed::Job.count > MAX_TASK / 2 || (!(ModuleInstance.need_refresh? || Student.need_refresh?) && Delayed::Job.count > 0)
                return false
            end
        end

        def discover_loop_refresh?
            Delayed::Job.uncached { MAX_TASK > Delayed::Job.count } && (ModuleInstance.need_refresh? || Student.need_refresh?)
        end

        def discover_loop_break?
            !(ModuleInstance.need_refresh? || Student.need_refresh? || Delayed::Job.uncached { Delayed::Job.count > 0 })
        end

        # noinspection RubyClassVariableUsageInspection
        def discover_loop_refresh
            ModuleInstance.refresh unless Student.refresh
        end

        def discover_loop
            $redis.flushall
            SerializedException.destroy(SerializedException.pluck(:id))
            loop do
                sleep(WAITING_TIME) while discover_loop_sleep?
                discover_loop_refresh while discover_loop_refresh?
                break if discover_loop_break?
            end
            Student.after_refresh
        end

        def discover_students
            wait_end_tasks
            semester_parser = SemesterParser.new
            Student.transaction do
                semester_parser.semesters_students_list.each do | student_attributes |
                    Student.try_create student_attributes.slice('login')
                end
            end
        end

        def discover_users
            User.all.each do |user|
                user.delay.store_epitech_groups
            end
        end

        def discover_student(student_attributes)
            (student_attributes.slice('login'))
        end

        def wait_end_tasks
            while Delayed::Job.uncached {Delayed::Job.count > 0}
                sleep(1)
            end
        end
    end
end