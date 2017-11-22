class InstanceActivityGroupStudentRelationship < ActiveRecord::Base
    belongs_to :student
    belongs_to :group, class_name: 'InstanceActivityGroup', foreign_key: 'instance_activity_group_id'
    has_many :leader_involved, through: :group, source: 'leader'
    has_many :members_involved, through: :group, source: 'members'
    has_many :students, through: :group
    has_one :project, through: :group
    has_one :module_instance, through: :project
    has_one :module_activity, through: :project
    has_one :epitech_module, through: :module_instance
end
