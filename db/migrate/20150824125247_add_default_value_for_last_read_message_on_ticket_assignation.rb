class AddDefaultValueForLastReadMessageOnTicketAssignation < ActiveRecord::Migration
    def change
        change_column :ticket_assignations, :last_read_message_id, :integer, default: 0
    end
end
