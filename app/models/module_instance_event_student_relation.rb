class ModuleInstanceEventStudentRelation < ActiveRecord::Base
    belongs_to :student
    belongs_to :event, class_name: 'ModuleInstanceEvent'
    has_one :module_activity, through: :event
    has_one :module_instance_activity_relation, :through => :event
end
