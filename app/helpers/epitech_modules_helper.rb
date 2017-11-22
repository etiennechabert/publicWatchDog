module EpitechModulesHelper
    def modules_list
        result = EpitechModule.select(:semester).distinct.map do |s|
            {
                semester: s.semester, modules: EpitechModule.where(semester: s.semester).map do |m|
                {
                    id: m.id,
                    name: m.name
                }
            end
            }
        end.sort_by {|elem| elem[:semester]}
        result.delete_if { |elem| elem[:semester] == -1 }
    end

    def epitech_module_print_semester epitech_module
        if epitech_module.semester
            return "Semester : #{epitech_module.semester.name}"
        end
        "Semester : No particualar semester link"
    end

    def epitech_module_print_credits epitech_module
        "Credits : #{epitech_module.credits}"
    end
end
