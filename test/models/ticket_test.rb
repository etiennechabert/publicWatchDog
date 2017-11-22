require 'test_helper'

class TicketTest < ActiveSupport::TestCase
    test "Basic create" do
        ticket = Ticket.create(user: FactoryGirl.create(:user), student: FactoryGirl.create(:student), description: 'test', title: 'test title', category: 0)
        assert ticket
        assert_not_empty ticket.ticket_assignations
    end

    test "New_one tickets getter" do
        FactoryGirl.create(:ticket, status: :new_one)

        assert_not_empty Student.last.tickets.new_one
        Student.last.tickets.new_one.each do |ticket|
            assert_equal('new_one', ticket.status)
        end
    end

    test "Working_on tickets getter" do
        FactoryGirl.create(:ticket, status: :working_on)

        assert_not_empty Ticket.working_on
        Student.last.tickets.working_on.each do |ticket|
            assert_equal('working_on', ticket.status)
        end
    end

    test "Pending tickets getter" do
        FactoryGirl.create(:ticket, status: :pending)

        assert_not_empty Student.last.tickets.pending
        Student.last.tickets.pending.each do |ticket|
            assert_equal('pending', ticket.status)
        end
    end

    test "Sovled tickets getter" do
        FactoryGirl.create(:ticket, status: :solved)

        assert_not_empty Student.last.tickets.solved
        Student.last.tickets.solved.each do |ticket|
            assert_equal('solved', ticket.status)
        end
    end

    test "Not Solved tickets getter" do
        student = FactoryGirl.create(:student)
        FactoryGirl.create(:ticket, status: :new_one, student: student)
        FactoryGirl.create(:ticket, status: :pending, student: student)
        FactoryGirl.create(:ticket, status: :working_on, student: student)
        FactoryGirl.create(:ticket, status: :solved, student: student)

        assert_equal(3, Ticket.not_solved(Student.last).length)
        Ticket.not_solved(Student.last).each do |ticket|
            assert_not_equal('solved', ticket.status)
        end
    end

end