require 'epitech_request'

class SchoolParser
    def initialize
        @request = EpitechRequest.new
    end

    def schools_list
        @request.get_semesters_list['schools']
    end
end