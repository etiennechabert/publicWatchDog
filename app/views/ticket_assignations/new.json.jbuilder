json.array! @possible_users do |user|
    json.id user.login
    json.label user.login
end