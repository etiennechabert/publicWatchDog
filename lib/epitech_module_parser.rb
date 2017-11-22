require 'epitech_request'

class EpitechModuleParser
    def initialize
        @request = EpitechRequest.new
    end

    def modules_list
        @request.get_instances_list.map do |e|
            e['codemodule'] = e.extract!('code').values.first
            e
        end
    end

    def module_details(year, code, instance)
        begin
            {
                details: @request.get_module_detail(year, code, instance),
                registered_students: @request.get_module_registered(year, code, instance),
                students_grades: @request.get_module_grades(year, code, instance),
                students_presence: @request.get_module_presences(year, code, instance)
            }
        rescue => e
            SerializedException.create({
                                           class_name: 'EpitechModuleParser:module_details',
                                           exception_message: e.to_s,
                                           serialized_instance: {year: year, code: code, instance: instance}.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    private

end