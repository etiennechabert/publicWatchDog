json.cities do
    json.array! ModuleInstance.where(epitech_module_id: @module_activity.epitech_module_id).order(:location).select(:location, :code).distinct.each do |instance|
        json.location "#{instance.location}-#{instance.code}"
    end
end
json.years do
    json.array! ModuleInstance.where(epitech_module_id: @module_activity.epitech_module_id).order(:scholar_year).select(:scholar_year).distinct.each do |instance|
        json.scholar_year instance.scholar_year
    end
end
json.data do
    json.array! @module_activity.module_instance_activity_relations_extended.each do |module_instance_relation|
        unless module_instance_relation.average_grades.nan?
            json.id module_instance_relation.module_instance.code
            json.location "#{module_instance_relation.module_instance.location}-#{module_instance_relation.module_instance.code}"
            json.scholar_year module_instance_relation.module_instance.scholar_year
            json.value module_instance_relation.average_grades
        end
    end
end
