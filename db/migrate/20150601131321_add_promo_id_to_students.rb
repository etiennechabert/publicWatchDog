class AddPromoIdToStudents < ActiveRecord::Migration
    def change
        add_column :students, :promo_id, :integer, default: nil
    end
end
