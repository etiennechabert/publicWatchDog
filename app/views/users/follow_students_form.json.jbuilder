def form_choices
    result = {}

    Student.select(:school_id, :course_semester_relation_id, :promo, :location).includes(:school, :course, :semester).distinct.each do |student|
        result[:school] = {} unless result[:school]
        next unless student.school
        result[:school][student.school.id] = {id: student.school.id, name: student.school.name, course: {}} unless result[:school][student.school.id]
        next unless student.course
        result[:school][student.school.id][:course][student.course.id] = {id: student.course.id, name: student.course.name, semester: {}} unless result[:school][student.school.id][:course][student.course.id]
        next unless student.semester
        result[:school][student.school.id][:course][student.course.id][:semester][student.semester.id] = {id: student.semester.id, name: student.semester.name, promo: {}} unless result[:school][student.school.id][:course][student.course.id][:semester][student.semester.id]
        next unless student.promo
        result[:school][student.school.id][:course][student.course.id][:semester][student.semester.id][:promo][student.promo] = {id: student.promo, name: student.promo, location: {}} unless result[:school][student.school.id][:course][student.course.id][:semester][student.semester.id][:promo][student.promo]
        next unless student.location
        result[:school][student.school.id][:course][student.course.id][:semester][student.semester.id][:promo][student.promo][:location][student.location] = {id: student.location, name: student.location, student: Student.select(:id, :login).where(school_id: student.school.id, course_semester_relation_id: student.course_semester_relation_id, promo: student.promo, location: student.location).order(:login).map{|student| {id: student.login, name: student.login}}}
    end

    result
end

json.form_fields form_choices
