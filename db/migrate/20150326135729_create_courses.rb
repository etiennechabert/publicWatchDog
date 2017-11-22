class CreateCourses < ActiveRecord::Migration
    def change
        create_table :courses do |t|
            t.string :degree, nil: false
            t.string :degree_type
            t.integer :school_id, nil: false

            t.index [:degree, :degree_type], unique: true
            t.timestamps null: false
        end
    end
end
