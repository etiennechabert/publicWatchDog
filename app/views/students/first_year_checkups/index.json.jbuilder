json.array!(@first_year_checkups) do |first_year_checkup|
  json.extract! first_year_checkup, :id
  json.url first_year_checkup_url(first_year_checkup, format: :json)
end
