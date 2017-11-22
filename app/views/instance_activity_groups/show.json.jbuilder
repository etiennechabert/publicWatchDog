json.project_days @group.project.project_days
@group.students.each do |student|
    json.set! student.login do
        json.login student.login
        json.netsoul @group.project.netsoul_for_student(student)
    end
end