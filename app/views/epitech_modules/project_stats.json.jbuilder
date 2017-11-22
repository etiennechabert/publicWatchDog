json.code_module @epitech_module.code
json.projects do
    json.array! @epitech_module.projects do |project|
        json.id project['id']
        json.name project['title']
        json.array! @epitech_module.module_instances do |instance|
            json.code_instance instance.code
            json.scholar_year instance.scholar_year
            instance.module_instance_activity_relations.where(module_activity_id: project['id']).each do |relation|
                json.array! relation.grades.select(:grade) do |grade|
                    json.grade grade.grade
                    break
                end
                break
            end
            break
        end
    end
end
