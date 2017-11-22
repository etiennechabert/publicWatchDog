require 'epitech_request'

class EpitechActivityParser
    def initialize
        @request = EpitechRequest.new
    end

    def activity(year, module_code, instance_code, activity_code)
        @request.get_activity(year, module_code, instance_code, activity_code)
    end

    def event_registered(year, module_code, instance_code, activity_code, event_code)
        @request.get_event_registered(year, module_code, instance_code, activity_code, event_code)
    end

    def grades_list(year, module_code, instance_code, activity_code)
        @request.get_activity_grades(year, module_code, instance_code, activity_code)
    end

    def groups_list(year, module_code, instance_code, activity_code)
        results = @request.get_activity_groups(year, module_code, instance_code, activity_code)
        {registered: results['registered'], not_registered: results['notregistered']}
    end
end