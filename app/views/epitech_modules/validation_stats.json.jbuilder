json.code_module @epitech_module.code
json.cities @epitech_module.cities
json.scholar_years @epitech_module.years
json.grades ModuleInstanceStudentRelation.existing_grades
json.instances do
    json.array! @epitech_module.module_instances.order(:scholar_year, :code).each do |instance|
        elements = instance.module_instance_student_relations.where(grade: ['A','B','C','D','E']).to_a
        total = elements.size
        next if total == 0
        json.scholar_year instance.scholar_year
        json.city instance.code
        json.A elements.clone.delete_if {|e| e.grade != 'A'}.size
        json.B elements.clone.delete_if {|e| e.grade != 'B'}.size
        json.C elements.clone.delete_if {|e| e.grade != 'C'}.size
        json.D elements.clone.delete_if {|e| e.grade != 'D'}.size
        json.E elements.clone.delete_if {|e| e.grade != 'E'}.size
        json.total total
    end
end