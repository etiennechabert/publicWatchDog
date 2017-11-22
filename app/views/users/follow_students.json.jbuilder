json.array! @students do |student|
    json.id student.id
    json.login student.login
    json.location student.location
    json.promo student.promo
    json.semester student_print_semester_name student
    json.picture student.picture
end