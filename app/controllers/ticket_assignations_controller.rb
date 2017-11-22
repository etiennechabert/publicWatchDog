class TicketAssignationsController < ApplicationController
    before_action :set_ticket, only: [:new, :create, :self_track, :stop_track]

    def new
        @possible_users = @ticket.possible_assignations(params['term'])
    end

    def create
        assigned_users = @ticket.users.length
        params[:logins].each do |login|
            @ticket.assign_to User.find_by_login(login), current_user
        end
        flash[:success] = "You have successfully assigned #{@ticket.users.length - assigned_users} people(s)"
        render nothing: true
    end

    def self_track
        @ticket.assign_to current_user
        redirect_to ticket_path(@ticket), flash: {success: 'You have successfully followed this ticket'}
    end

    def stop_track
        @ticket.remove_assignation(current_user)
        redirect_to ticket_path(@ticket), flash: {danger: 'You are not following this ticket anymore'}
    end

    private
    def set_ticket
        @ticket = Ticket.find(params[:ticket_id])
    end
end
