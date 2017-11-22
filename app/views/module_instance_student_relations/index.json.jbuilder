json.array!(@module_instance_student_relations) do |epitech_module_instance_student_relationship|
  json.extract! epitech_module_instance_student_relationship, :id
  json.url epitech_module_instance_student_relationship_url(epitech_module_instance_student_relationship, format: :json)
end
