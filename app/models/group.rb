class Group < ActiveRecord::Base
    has_many :group_user_relations, dependent: :destroy
    has_many :users, through: :group_user_relations

    enum access_level: {
             forbidden: 0,
             assistant: 1,
             ape: 2,
             dpra: 30,
             dpr: 40,
             admin: 42
         } # I defined some weird values for the 3 lasts role to be able to 'insert' new roles without difficulties

    before_save :humanize_title

    def humanize_title
        self.title = self.title.humanize
    end

    def self.user_groups_to_string(user)
        user.groups.pluck(:title).join(',')
    end
end
