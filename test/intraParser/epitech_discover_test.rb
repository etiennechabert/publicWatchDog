require 'test_helper'

class EpitechDiscover < ActiveSupport::TestCase

    test 'Basic start discover' do
        EpitechDiscover.discover
    end

    test 'Basic Student Discover' do
        student = Student.try_create({'login' => 'chaber_e'})
        student.discover_details
    end

end