require 'test_helper'

class ActivityParserTest < ActiveSupport::TestCase
    test "Grade list test (42sh 2014 Paris)" do
        parser = EpitechActivityParser.new

        assert_not_empty parser.grades_list(2014, 'B-PSU-155', 'PAR-2-1', 'acti-175772')
    end

    test "Registred People test (42sh 2014 Paris)" do
        parser = EpitechActivityParser.new

        result = parser.groups_list(2014, 'B-PSU-155', 'PAR-2-1', 'acti-175772')

        assert_equal result[:registered].class, Array
        assert_equal result[:not_registered].class, Array
    end
end