require 'test_helper'

class TicketMessageTest < ActiveSupport::TestCase
    test "Creation first message" do
        ticket = FactoryGirl.create(:ticket)

        assert_not_empty TicketMessage.all
        assert_equal(TicketMessage.first, ticket.last_message)
    end
end
