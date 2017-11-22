json.array!(@semesters) do |semester|
    json.id semester.id
    json.label semester.name
end
