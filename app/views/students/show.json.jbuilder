json.netsoul do
    {
        "weeks" => [
            @student.logs_sum_for_period(4.week.ago.to_date, 3.week.ago.to_date),
            @student.logs_sum_for_period(3.week.ago.to_date, 2.week.ago.to_date),
            @student.logs_sum_for_period(2.week.ago.to_date, 1.week.ago.to_date),
            @student.logs_sum_for_period(1.week.ago.to_date, 0.week.ago.to_date)
        ],
        "months" => [
            @student.logs_sum_for_period(3.month.ago.to_date, 2.month.ago.to_date),
            @student.logs_sum_for_period(2.month.ago.to_date, 1.month.ago.to_date),
            @student.logs_sum_for_period(1.month.ago.to_date, 0.month.ago.to_date)
        ]
    }.each do |k, v|
        json.set! k do
            json.labels do
                json.array! v.map { |e| "#{e[:date_to]}"  }
            end
            json.datasets do
                json.array! [@student.login, 'Promo'] do |element|
                    json.label element
                    if element == 'Promo'
                        json.fillColor "rgba(220,220,220,0.5)"
                        json.strokeColor "rgba(220,220,220,1)"
                        json.pointColor "rgba(220,220,220,1)"
                        json.pointStrokeColor "#fff"
                        json.pointHighlightFill "#fff"
                        json.pointHighlightStroke "rgba(220,220,220,1)"
                        json.data do
                            json.array! v.map { |e| e[:promo_average] / 60 / 60 }
                        end
                    else
                        json.fillColor "rgba(98, 105, 255,0.5)"
                        json.strokeColor "rgba(151,187,255,1)"
                        json.pointColor "rgba(151,187,255,1)"
                        json.pointStrokeColor "rgba(0,0,255,1)"
                        json.pointHighlightFill "rgba(0,0,255,1)"
                        json.pointHighlightStroke "rgba(204,216,255,1)"
                        json.data do
                            json.array! v.map { |e| e[:active_at_school] / 60 / 60 }
                        end
                    end
                end
            end
        end
    end
end

json.modules do
    json.array! @student.module_instance_student_relations.includes(:module_instance, :epitech_module, :grades, :module_activities) do |instance_relation|
        json.id instance_relation.module_instance.id
        json.name "#{instance_relation.module_instance.epitech_module.name}(#{instance_relation.module_instance.epitech_module.code} / #{instance_relation.module_instance.code})"
        json.scholar_year instance_relation.module_instance.scholar_year
        json.credits instance_relation.credits
        json.grade instance_relation.grade
        json.average instance_relation.average
        json.promo_min instance_relation.module_instance.min
        json.promo_max instance_relation.module_instance.max
        json.grades do
            json.array! instance_relation.grades do |grade|
                json.id grade.module_instance_activity_relation.id
                json.promo_min grade.module_instance_activity_relation.min
                json.promo_max grade.module_instance_activity_relation.max
                json.name grade.module_activity.title
                json.date grade.date
                json.grade grade.grade
                json.comment grade.comment
            end
        end
    end
end
