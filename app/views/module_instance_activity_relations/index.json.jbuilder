json.array!(@module_instance_activity_relations) do |epitech_module_instance_activity|
  json.extract! epitech_module_instance_activity, :id
  json.url epitech_module_instance_activity_url(epitech_module_instance_activity, format: :json)
end
