class CreateTicketAssignations < ActiveRecord::Migration
    def change
        create_table :ticket_assignations do |t|
            t.integer   :ticket_id, null: false
            t.integer   :user_id, null: false
            t.integer   :last_read_message_id, default: nil
            t.boolean   :ignored, default: false

            t.index     :user_id
            t.index     [:user_id, :ticket_id], unique: true
            t.timestamps null: false
        end
    end
end
