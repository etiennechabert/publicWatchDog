class CreateTicketMessages < ActiveRecord::Migration
    def change
        create_table    :ticket_messages do |t|
            t.integer   :ticket_id, null: false
            t.integer   :user_id, null: false
            t.text      :message, null: false

            t.index     :ticket_id
            t.index     :user_id
            t.timestamps null: false
        end
    end
end
