module AssignUsers
    extend ActiveSupport::Concern

    def assign_users(attributes)
        key = attributes.keys.first
        values = attributes.values.first
        values = [] unless values

        users_to_assign = values.map do |e|
            next unless e['type'] == 'user'
            User.find_or_create_by({login: e['login']})
        end
        users_to_assign.compact!

        self.update_attribute(key, users_to_assign)
    end
end