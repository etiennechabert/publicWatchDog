json.array!(@epitech_modules) do |epitech_module|
  json.extract! epitech_module, :id
  json.url epitech_module_url(epitech_module, format: :json)
end
