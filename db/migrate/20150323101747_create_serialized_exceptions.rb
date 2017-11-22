class CreateSerializedExceptions < ActiveRecord::Migration
    def change
        create_table :serialized_exceptions do |t|
            t.string :class_name
            t.string :exception_class
            t.text :exception_message, :limit => 4294967295
            t.text :serialized_instance, :limit => 4294967295
            t.text :serialized_stack, :limit => 4294967295

            t.timestamps null: false
        end
    end
end
