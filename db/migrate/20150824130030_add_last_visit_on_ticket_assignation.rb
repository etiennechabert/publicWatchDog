class AddLastVisitOnTicketAssignation < ActiveRecord::Migration
    def change
        add_column :ticket_assignations, :last_visit, :datetime, default: nil
    end
end
