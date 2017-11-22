class CreateTickets < ActiveRecord::Migration
    def change
        create_table    :tickets do |t|
            t.integer   :student_id, null: false
            t.integer   :user_id, null: false
            t.integer   :last_message_id, null: false, default: 0
            t.string    :title, null: false
            t.integer   :category, null: false      #enum
            t.integer   :status, default: 0, null: false     #enum

            t.index     :student_id
            t.index     :user_id
            t.index     :status
            t.index     :category
            t.timestamps null: false
        end
    end
end
