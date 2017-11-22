json.array!(@grades) do |grade|
  json.extract! grade, :id
  json.url grade_url(grade, format: :json)
end
