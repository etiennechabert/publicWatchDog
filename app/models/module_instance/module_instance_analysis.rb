module ModuleInstance::ModuleInstanceAnalysis
    extend ActiveSupport::Concern

    module ClassMethods

        def students_stats(students, scholar_year)
            result = $redis.get(students_redis_key(students, scholar_year))
            return JSON.parse(result) if result
            module_instance_student_relations = ModuleInstanceStudentRelation.where(student_id: students.pluck(:id), module_instance_id: ModuleInstance.where(scholar_year: scholar_year).pluck(:id)).includes(:grades, :module_activities, :student, :epitech_module)
            final_result = {
                students: {},
                max: students_hash_default_result(nil),
                min: students_hash_default_result(nil)
            }
            module_instance_student_relations.each do |relation|
                final_result[:students][relation.student.login] = students_hash_default_result unless final_result[:students][relation.student.login]
                relation.grades.each do |grade|
                    student_stats_grades(final_result[:students][relation.student.login][:result], grade)
                end
                student_stats_module(final_result[:students][relation.student.login][:result], final_result[:students][relation.student.login][:gpa], relation)
            end
            students_stats_gpa(final_result[:students])
            students_stats_max(final_result)
            students_stats_min(final_result)
            $redis.setex(students_redis_key(students, scholar_year), $redis_default_expiration, final_result.to_json)
            JSON.parse final_result.to_json
        end

        def correlation_stats(students_stats)
            correlation_hash = correlation_stats_init_hash(students_stats['students'].first[1]['result'])
            correlation_stats_build_hash(students_stats, correlation_hash)
            correlation_result = correlation_stats_init_relation(correlation_hash)
            correlation_computation(correlation_hash, correlation_result)
            correlation_result
        end

        private

        def correlation_stats_init_hash(student_data)
            result = {}
            student_data.keys.each do |k|
                result[k] = []
            end
            result
        end

        def correlation_stats_build_hash(students_stats, correlation_hash)
            students_stats['students'].each do |student_login, student_data|
                correlation_hash.each do |k, v|
                    v.push(student_data['result'][k])
                end
            end
        end

        def correlation_stats_init_relation(correlation_hash)
            correlation_result = {}
            correlation_hash.keys.each_with_index do |k1, index1|
                correlation_hash.keys.each_with_index do |k2, index2|
                    next if index1 == index2
                    correlation_result[k1] = {} unless correlation_result[k1]
                    correlation_result[k1][k2] = 0
                end
            end
            correlation_result
        end

        def correlation_computation(correlation_hash, correlation_result)
            linefit = LineFit.new
            correlation_result.each do |relation1, elements|
                elements.each do |relation2, element|
                    linefit.setData(correlation_hash[relation1], correlation_hash[relation2])
                    elements[relation2] = linefit.rSquared
                end
            end
        end

        def students_redis_key(students, scholar_year)
            'module_instance_analysis-'+students_md5_signature(students)+"-#{scholar_year}"
        end

        def students_md5_signature(students)
            Digest::MD5.hexdigest students.pluck(:id).to_json
        end

        def students_hash_default_result(default_value = 0)
            {
                result: {
                    exams_missed: default_value, exams_failed: default_value, exams_success: default_value,
                    projects_missed: default_value, projects_failed: default_value, projects_success: default_value, projects_cheated: default_value,
                    credits_own: default_value, credits_failed: default_value, credits_pending: default_value, credits_possible: default_value,
                    modules_success: default_value, modules_failed: default_value, modules_pending: default_value,
                    gpa: default_value
                },
                gpa: {E: 0, D: 0, C: 0, B: 0, A: 0}
            }
        end

        def students_stats_gpa(result)
            result.each do |k, element|
                student_stats_gpa(element[:result], element[:gpa])
            end
        end

        def students_stats_max(result)
            result[:students].each do |student_login, values|
                values[:result].each do |k, v|
                    result[:max][:result][k] = v unless result[:max][:result][k]
                    result[:max][:result][k] = v if result[:max][:result][k] < v
                end
            end
        end

        def students_stats_min(result)
            result[:students].each do |student_login, values|
                values[:result].each do |k, v|
                    result[:min][:result][k] = v unless result[:min][:result][k]
                    result[:min][:result][k] = v if result[:min][:result][k] > v
                end
            end
        end

        def student_stats_gpa(result, gpa_result)
            result[:credits_possible] = result[:credits_own] + result[:credits_pending]
            result[:gpa] = (((4 * gpa_result[:A]) + (3 * gpa_result[:B]) + (2 * gpa_result[:C]) + (1 * gpa_result[:D])).to_f /
                (gpa_result[:A] + gpa_result[:B] + gpa_result[:C] + gpa_result[:D] + gpa_result[:E]).to_f).round(2)
        end

        def student_stats_module(result, gpa_result, module_instance_relation)
            case module_instance_relation.grade
                when '-'
                    result[:modules_pending] += 1
                    result[:credits_pending] += module_instance_relation.credits
                    return
                when 'ACQUIS'
                    result[:credits_own] += module_instance_relation.credits
                    result[:modules_success] += 1
                    return
                when 'A', 'B', 'C', 'D'
                    result[:credits_own] += module_instance_relation.credits
                    result[:modules_success] += 1
                else
                    result[:credits_failed] += module_instance_relation.credits
                    result[:modules_failed] += 1
            end
            gpa_result[module_instance_relation.grade.to_sym] += module_instance_relation.epitech_module.credits
        end

        def student_stats_grades(result, grade)
            case grade.module_activity.activity_code
                when 'rdv', 'proj', 'other'
                    if grade.grade > 2
                        result[:projects_success] += 1
                    elsif grade.grade == 0 || grade.grade == 0.5 || grade.grade == -21
                        result[:projects_missed] += 1
                    elsif grade.grade == -42 || grade.grade == -84
                        result[:projects_cheated] += 1
                    else
                        result[:projects_failed] += 1
                    end
                when 'exam'
                    if grade.grade >= 15
                        result[:exams_success] += 1
                    elsif grade.comment && grade.comment.include?('Absent')
                        result[:exams_missed] += 1
                    else
                        result[:exams_failed] += 1
                    end
                when 'tp'
                else
            end
        end
    end
end
