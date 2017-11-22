require 'test_helper'

class TicketAssignationTest < ActiveSupport::TestCase
    test "Just check relation" do
        FactoryGirl.create(:ticket)

        assert_equal(User, TicketAssignation.first.user.class)
        assert_equal(Ticket, TicketAssignation.first.ticket.class)
    end

    test "Assign a new user" do
        ticket = FactoryGirl.create(:ticket)
        ticket.assign_to(FactoryGirl.create(:user))

        assert_equal(ticket.users.length, 2)
    end

    test "Last read message 1" do
        ticket = FactoryGirl.create(:ticket)

        assert_equal(TicketAssignation.first.last_read_message, ticket.last_message)
        assert_equal(TicketAssignation.first.something_new?, false)
    end

    test "Last read message 2" do
        ticket = FactoryGirl.create(:ticket)
        user = FactoryGirl.create(:user)

        ticket.assign_to(user)

        assert_equal(TicketAssignation.last.user, user)
        assert_not_equal(TicketAssignation.last.last_read_message, ticket.last_message)
        assert_equal(TicketAssignation.last.something_new?, true)
    end
end
