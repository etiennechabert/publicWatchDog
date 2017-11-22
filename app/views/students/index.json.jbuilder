json.array!(@students) do |student|
    json.id student.login
    student.login = "#{student.login} - #{student.promo}(#{student.location})" unless params[:short]
    json.label student.login
end
