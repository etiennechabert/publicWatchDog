json.array!(@second_year_checkups) do |second_year_checkup|
  json.extract! second_year_checkup, :id
  json.url second_year_checkup_url(second_year_checkup, format: :json)
end
