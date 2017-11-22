require 'test_helper'

class StudentParserTest < ActiveSupport::TestCase
    test 'Valid student parsing test' do
        result = EpitechStudentParser.new('bis_s')
        assert_not_empty result.binomes
        assert_not_empty result.modules
        assert_not_empty result.log_netsoul
        assert_not_empty result.user_details
    end

    test 'invalid student parsing test' do
        assert_raise EpitechRequest::NotFound do
            EpitechStudentParser.new('bis_ss')
        end
    end

    test 'Log netsoul analysis' do
        student = EpitechStudentParser.new('bis_s')
        netsoul_logs = student.log_netsoul

        assert_not_empty netsoul_logs[:monthly]
        assert_equal netsoul_logs[:monthly].length, 3
        assert_not_empty netsoul_logs[:weekly]
        assert_equal netsoul_logs[:weekly].length, 4
    end

end