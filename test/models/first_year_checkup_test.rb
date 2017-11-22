require 'test_helper'

class FirstYearCheckupTest < ActiveSupport::TestCase
    test "basic creation" do
        assert FactoryGirl.create(:first_year_checkup)
    end
end
