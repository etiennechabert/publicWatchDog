class TicketAssignation < ActiveRecord::Base
    belongs_to :user
    belongs_to :ticket
    belongs_to :last_read_message, class_name: TicketMessage

    def something_new?
        self.last_read_message != ticket.last_message
    end

end
