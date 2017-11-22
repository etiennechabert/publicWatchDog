require 'test_helper'

class UserTest < ActiveSupport::TestCase

    def generate_students
        user = FactoryGirl.create(:user)
        students = FactoryGirl.create_list(:student, 100)
        user.students << students
        user.students.each_with_index {|student, i| yield student, i}
        user.students << FactoryGirl.create(:student)
        user
    end

    test 'Students last checkups' do
        user = generate_students{ |student, i| student.update_attribute(:last_checkup_date, Date.today().days_ago(i)) }

        assert_equal(user.students_last_checkup_date, {:today=>1, :this_week=>6, :two_weeks=>7, :this_month=>17, :older=>70})
    end

    test 'Students chances' do
        user = generate_students{ |student, i| student.update_attribute(:success_chance, i/ 10 *10 ) }

        assert_equal(user.students_last_chance, {nil=>1, 0=>10, 10=>10, 20=>10, 30=>10, 40=>10, 50=>10, 60=>10, 70=>10, 80=>10, 90=>10})
    end
end
