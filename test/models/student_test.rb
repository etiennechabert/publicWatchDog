require 'test_helper'

class StudentTest < ActiveSupport::TestCase
    test "Update close date when close change" do
        s = FactoryGirl.create(:student)
        assert_nil(s.close)
        assert_nil(s.close_date)
        s.close = 'test'
        s.save
        assert_equal(s.close_date, Date.today)
    end

    test "Discover process for a basic student" do
        Student.try_create({login: 'bis_s'})
    end
end
