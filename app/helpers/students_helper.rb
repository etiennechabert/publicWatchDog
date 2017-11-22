module StudentsHelper
    def promo_list_printable
        out_result = nil
        good_result = []
        Student.select(:promo).distinct.each do |res|
            unless res.promo.nil?
                good_result << {name: res.promo, number: Student.where(promo: res.promo).count}
            else
                out_result = {name: 'Out', number: Student.where(promo: res.promo).count}
            end
        end
        good_result.sort_by{|elem| -elem[:name]} << out_result
    end

    def netsoul_analysis_value_print(val)
        return "None" if val == 0
        "#{val / 60 / 60}h#{val / 60 % 60}m"
    end

    def netsoul_analysis_pourcent(val1, val2)
        return "Undifined" if val1 == 0 || val2 == 0
        (((val1.to_f - val2.to_f) / val2.to_f) * 100.to_f).round(0)
    end

    def student_print_school_name student
        return student.school.name.humanize if student.school
        'None'
    end

    def student_print_semester_name student
        return student.semester.name if student.semester
        'Out of school'
    end

    def student_print_credits
        res = "#{@student.credits}"
        return res + " / #{@student.semester.expected_credits}" if @student.semester
        res + " / Out of school"
    end
end
