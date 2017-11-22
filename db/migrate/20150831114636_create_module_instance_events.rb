class CreateModuleInstanceEvents < ActiveRecord::Migration
    def change
        create_table        :module_instance_events do |t|
            t.integer       :code, null: false
            t.integer       :activity_id, null: false
            t.datetime      :datetime, null: false

            t.index         :activity_id
            t.timestamps    null: false
        end
    end
end
