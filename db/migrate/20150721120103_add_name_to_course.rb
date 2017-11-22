class AddNameToCourse < ActiveRecord::Migration
    def change
        add_column :courses, :name, :string, default: ''
        add_index :courses, :name
    end
end
