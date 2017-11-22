class TicketMessage < ActiveRecord::Base
    belongs_to :ticket
    belongs_to :user

    attr_accessor :category
    attr_accessor :status

    after_save :update_ticket_attributes

    def update_ticket_attributes
        self.ticket.status = status if status
        self.ticket.category = category if category
        if self.ticket.changed?
            log_difference
        end
    end

    private

    def log_difference
        modification_data = JSON.parse self.modification
        if self.ticket.status_changed?
            modification_data[:status] = "#{self.ticket.status_was} -> #{self.ticket.status}"
        end
        if self.ticket.category_changed?
            modification_data[:category] = "#{self.ticket.category_was} -> #{self.ticket.category}"
        end
        self.modification = modification_data.to_json
        self.ticket.save
        self.save if self.changed?
    end
end
