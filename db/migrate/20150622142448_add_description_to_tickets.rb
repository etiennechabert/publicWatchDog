class AddDescriptionToTickets < ActiveRecord::Migration
  def change
      add_column :tickets, :description, :text, null: false
  end
end
