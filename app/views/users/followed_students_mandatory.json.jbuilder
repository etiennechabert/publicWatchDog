def students_mandatories(data)
    result = {}
    data.each do |row|
        result[row.student.login] = {
            login: row.student.login,
            location: row.student.location,
            promo: row.student.promo,
            credits: row.student.credits,
            modules: {}
        } unless result[row.student.login]
        result[row.student.login][:modules][row.epitech_module.code] = {
            code: row.epitech_module.code,
            instances: []
        } unless result[row.student.login][:modules][row.epitech_module.code]
        result[row.student.login][:modules][row.epitech_module.code][:instances].push({scholar_year: row.module_instance.scholar_year, grade: row.grade})
    end
    result
end

result = {}
CourseSemesterRelation.where(id: @students.select(:course_semester_relation_id).distinct.map {|e| e.course_semester_relation_id}).includes(:semester, :course).each do |course_semester|
    result[course_semester.id] = {
        name: "#{course_semester.course.name} #{course_semester.semester.name}",
        mandatory_modules: course_semester.mandatory_modules.select(:name,  :code, :credits, :credits, :course_mandatory, :year_mandatory, :mandatory).order(:code),
        students_number: @students.where(course_semester_relation: course_semester).count,
        students: students_mandatories(ModuleInstanceStudentRelation.where(student: @students, module_instance: ModuleInstance.where(epitech_module: course_semester.mandatory_modules)).order(registration_date: 'DESC').includes(:student, :epitech_module, :module_instance))
    }
end

json.mandatory result