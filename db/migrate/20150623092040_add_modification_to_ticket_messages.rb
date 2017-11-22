class AddModificationToTicketMessages < ActiveRecord::Migration
    def change
        add_column :ticket_messages, :modification, :string, default: '{}'
    end
end
