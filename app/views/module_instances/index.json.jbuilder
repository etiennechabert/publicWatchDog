json.array!(@module_instances) do |epitech_module_instance|
  json.extract! epitech_module_instance, :id
  json.url epitech_module_instance_url(epitech_module_instance, format: :json)
end
