class ModuleActivity < ActiveRecord::Base
    include TranslateAttributes

    validates :epitech_module_id, presence: true
    validates :activity_title, presence: true
    validates :activity_code, presence: true

    has_many :module_instance_activity_relations, dependent: :destroy
    has_many :module_instances, through: :module_instance_activity_relations
    belongs_to :epitech_module

    ATTRIBUTES = ['title', 'description', 'type_title', 'type_code']
    TRANSLATE_ATTRIBUTES = {
        'type_title' => 'activity_title',
        'type_code' => 'activity_code'
    }

    # @param [Hash] attributes
    # @param [EpitechModule] epitech_module
    def self.try_create(attributes, epitech_module)
        epitech_module_activity = self.find_by(epitech_module_id: epitech_module.id, title: attributes['title'])
        return epitech_module_activity unless epitech_module_activity.nil?
        attributes = {epitech_module_id: epitech_module.id}.merge(translate_attributes(attributes))
        attributes['activity_title'] = 'Event' if attributes['activity_title'].nil?
        attributes['activity_code'] = 'other' if attributes['activity_code'].nil?
        return nil if attributes['title'].blank?

        begin
            create!(attributes)
        rescue Exception => e
            SerializedException.create({
                                           class_name: 'Module_activity:try_create',
                                           exception_message: e.to_s,
                                           serialized_instance: attributes.to_json,
                                           serialized_stack: e.backtrace.to_json
                                       })
        end
    end

    # Why : This hook is necessary because grade are sometimes link with '"#{Project}"' OR with 'Soutenance "#{Project}"'
    # So this methods give grade for both names
    def module_instance_activity_relations_extended
        activities = self.epitech_module.module_activities.where("title LIKE '%#{self.title}%'")
        ModuleInstanceActivityRelation.where(module_activity: activities).includes(:grades, :module_instance)
    end

end
