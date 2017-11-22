class AllowNullValueOnRegistrationDateForModuleStudent < ActiveRecord::Migration
    def change
        change_column :module_instance_student_relations, :registration_date, :date, null: true
    end
end
