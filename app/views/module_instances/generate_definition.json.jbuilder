json.definition do
    json.target 'grade'
    @module_instance.projects_definition.each do |project|
        json.set!(project.module_activity.title, '[ordered] F,G,GG')
    end
    json.grade @module_instance.possible_grades
end

json.data do
    json.array! @module_instance.students.each do |student|
        @module_instance.projects_definition.each do |project|
            json.set!(project.module_activity.title, @module_instance.grade_for_activity_student(project, student))
        end
        json.grade @module_instance.module_instance_student_relations.find_by_student_id(student.id).grade
    end
end
