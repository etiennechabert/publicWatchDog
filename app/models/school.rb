class School < ActiveRecord::Base
    include TranslateAttributes
    has_many :courses
    has_many :students
    has_many :semesters, through: :courses
    has_many :module_instances, through: :semesters

    validates :name, presence: true
    validates :short_name, presence: true

    ATTRIBUTES = ['code', 'nb_year', 'nb_semester', 'short']
    TRANSLATE_ATTRIBUTES = {
        'code' => 'name',
        'short' => 'short_name'
    }

    def self.try_create(attributes)
        school = self.find_by_name(attributes['code'])

        return school unless school.nil?

        attributes = translate_attributes(attributes)
        begin
            create!(attributes)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'School:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attributes.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    def self.school_select
        School.all.map { |school| [school.name.humanize, school.id] }
    end
end
