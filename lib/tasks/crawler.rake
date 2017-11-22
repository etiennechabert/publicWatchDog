# require 'newrelic_rpm'

namespace :crawler do
    task all: :environment do
        EpitechDiscover.discover
        EpitechDiscover.discover_loop
    end

    task init: :environment do
        EpitechDiscover.discover
    end

    task reset: :environment do
        ActiveRecord::Base.connection.execute("TRUNCATE delayed_jobs")
        ActiveRecord::Base.connection.execute("TRUNCATE epitech_modules")
        ActiveRecord::Base.connection.execute("TRUNCATE epitech_module_responsable_relations")
        ActiveRecord::Base.connection.execute("TRUNCATE grades")
        ActiveRecord::Base.connection.execute("TRUNCATE group_user_relations")
        ActiveRecord::Base.connection.execute("TRUNCATE instance_activity_groups")
        ActiveRecord::Base.connection.execute("TRUNCATE instance_activity_group_student_relationships")
        ActiveRecord::Base.connection.execute("TRUNCATE module_activities")
        ActiveRecord::Base.connection.execute("TRUNCATE module_instances")
        ActiveRecord::Base.connection.execute("TRUNCATE module_instance_activity_relations")
        ActiveRecord::Base.connection.execute("TRUNCATE module_instance_professor_relations")
        ActiveRecord::Base.connection.execute("TRUNCATE module_instance_student_relations")
        ActiveRecord::Base.connection.execute("UPDATE students SET grades_data = '' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE students SET crawler_stamp = '0001-01-01' WHERE 1")
    end

    task refresh_students: :environment do
        Student.all.each do |student|
            student.discover_details
        end
    end

    task refresh: :environment do
        EpitechDiscover.discover_loop
    end

    task force_refresh: :environment do
        ActiveRecord::Base.connection.execute("UPDATE students SET crawler_stamp = '0001-01-01' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE module_instances SET crawler_stamp = '0001-01-01', `corrupted` = false WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE grades SET data_hash = '' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE instance_activity_groups SET data_hash = '' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE module_instance_activity_relations SET grades_hash = '' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE module_instance_activity_relations SET groups_hash = '' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE module_instances SET activities_hash = '' WHERE 1")
        ActiveRecord::Base.connection.execute("UPDATE module_instances SET students_hash = '' WHERE 1")
        ActiveRecord::Base.connection.execute("DELETE FROM serialized_exceptions WHERE 1")
        ActiveRecord::Base.connection.execute("DELETE FROM delayed_jobs WHERE 1")
    end

    task debug_student: :environment do
        Student.try_create('login' => 'loofat_s').discover_details
    end

    task debug_module: :environment do
        epitech_module_parser = EpitechModuleParser.new
        ModuleInstance.try_create epitech_module_parser.module_details(scholar_year, self.code, instance['code'])[:details]
    end

    task stats: :environment do
        result = {}
        $redis.keys('request-statistics-*').each do |k|
            result[k] = $redis.get(k);
        end
        result.sort_by {|k, v| v}.each do |k,v|
            puts "#{k} -> #{v} hits"
        end
    end

    task extract_errors: :environment do
        SerializedException.all.each do |error|
            puts "#{error.class_name} : #{error.serialized_instance}"
        end
    end
end
