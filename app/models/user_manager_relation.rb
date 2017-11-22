class UserManagerRelation < ActiveRecord::Base
    belongs_to :manager, class_name: :user, foreign_key: :manager_id
    belongs_to :user, class_name: :user, foreign_key: :user_id
end
