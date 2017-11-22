require 'test_helper'

class GroupTest < ActiveSupport::TestCase
    test 'Try collision inserts' do
        assert_raise ActiveRecord::RecordNotUnique do
            Group.create({title: 'test'})
            Group.create({title: 'test'})
        end
    end

    test 'Shouln t create' do
        assert_raise ActiveRecord::StatementInvalid do
            Group.create!
        end
    end
end
