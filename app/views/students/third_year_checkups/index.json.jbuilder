json.array!(@third_year_checkups) do |third_year_checkup|
  json.extract! third_year_checkup, :id
  json.url third_year_checkup_url(third_year_checkup, format: :json)
end
