class TicketMessagesController < ApplicationController
    def create
        @ticket_message = TicketMessage.new(ticket_params.to_hash.merge({user: current_user, ticket_id: params[:ticket_id]}))

        respond_to do |format|
            if @ticket_message.save
                @ticket_message.ticket.update_attribute(:last_message_id, @ticket_message.id)
                format.html { redirect_to ticket_path(@ticket_message.ticket), success: 'Your Ticket message was successfully created.' }
            else
                format.html { render 'tickets/show', ticketMessage: @ticket_message }
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_message
        @ticket_message = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
        params[:ticket_message].permit([:category, :status, :message])
    end
end
