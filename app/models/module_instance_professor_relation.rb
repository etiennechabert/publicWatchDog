class ModuleInstanceProfessorRelation < ActiveRecord::Base
    belongs_to :module_instance
    belongs_to :professor, class_name: 'User', foreign_key: 'professor_id'
end
