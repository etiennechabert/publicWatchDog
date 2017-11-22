class EpitechModuleResponsableRelation < ActiveRecord::Base
    belongs_to :epitech_module
    belongs_to :responsable, class_name: 'User', foreign_key: 'responsable_id'
end
