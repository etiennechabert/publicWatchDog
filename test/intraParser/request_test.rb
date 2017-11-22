require 'test_helper'

class RequestTest < ActiveSupport::TestCase
    test 'Success login test' do
        assert  EpitechRequest.check_login('a_user', 'a_password')
        assert_not  EpitechRequest.check_login('a_bad_user', 'a_bad_password')
    end

    test 'No attributes request methods tests' do
        request = EpitechRequest.new

        assert_not_empty request.get_modules_list
        assert_not_empty request.get_interneships
        assert_not_empty request.get_semesters_list
        assert_not_empty request.get_semesters_students_list
    end

    test 'Users request methods tests' do
        request = EpitechRequest.new

        assert_not_empty request.get_user_details('chaber_e')
        assert_not_empty request.get_user_modules_and_grades('chaber_e')
        assert_not_empty request.get_user_netsoul('chaber_e')
        assert_not_empty request.get_user_binomes('chaber_e')
    end

    test 'Module instance tests' do
        request = EpitechRequest.new

        assert_not_empty request.get_module_detail(2014, 'B-PSU-155', 'PAR-2-1')
        assert_not_empty request.get_module_registered(2014, 'B-PSU-155', 'PAR-2-1')
        assert_not_empty request.get_module_grades(2014, 'B-PSU-155', 'PAR-2-1')
        assert_not_empty request.get_module_presences(2014, 'B-PSU-155', 'PAR-2-1')
    end

    test 'Module instance activity' do
        request = EpitechRequest.new

        assert_not_empty request.get_activity_grades(2014, 'B-PSU-155', 'PAR-2-1', 'acti-175772')
    end
end
