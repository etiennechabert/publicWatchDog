module Student::StudentDbHelpers
    extend ActiveSupport::Concern

    # Readme : For some reason values about student's grade evolution could be null, so we overload the getters to calc the value if missing
    def get_grades_evolution
        self.grades_evolution_calc unless grades_evolution
        return 0 unless grades_evolution
        grades_evolution
    end

    def get_grades_average_start
        self.grades_evolution_calc unless grades_average_start
        return 0 unless grades_average_start
        grades_average_start
    end

    def get_grades_average_end
        self.grades_evolution_calc unless grades_average_end
        return 0 unless grades_average_end
        grades_average_end
    end

    def get_grades_data
        self.grades_evolution_calc unless grades_data
        return 0 unless grades_data
        grades_data
    end

    def last_checkup_chance
        checkup = last_checkup
        return 0 unless checkup
        checkup.success_chance
    end

    def last_checkup
        checkup_relation = student_checkup_relations.order(id: 'desc').first
        return nil unless checkup_relation
        checkup_relation.checkup
    end

    def logs_for_period(period_start, period_end)
        period_start = period_start.to_date unless period_start.class == Date
        period_end = period_end.to_date unless period_end.class == Date
        self.parsed_logs = JSON.parse(self.logs) unless self.parsed_logs
        tmp = []
        date = period_start
        while date < period_end do
            if self.parsed_logs[date.to_s]
                tmp.push(self.parsed_logs[date.to_s])
            else
                tmp.push({:active_at_school=>0, :promo_average=>0})
            end

            date += 1.days
        end
        tmp
    end

    def logs_sum_for_period(period_start, period_end)
        tmp = logs_for_period(period_start, period_end)
        result = {active_at_school: 0, promo_average: 0}
        tmp.compact.each do |e|
            e.symbolize_keys!
            result[:active_at_school] += e[:active_at_school]
            result[:promo_average] += e[:promo_average]
        end
        result.merge({date_from: period_start, date_to: period_end})
    end

    def logs_evolution_for_period(period_start, period_end)
        linefit = LineFit.new
        tmp = logs_for_period(period_start, period_end)
        index = []
        values = []
        tmp.each_with_index do |element, i|
            index.push i
            values.push element[:active_at_school] / 60 / 60
        end
        linefit.setData(index, values, index)
        intercept, evolution = linefit.coefficients
        evolution.round(2)
    end

    def credits_pending
        self.module_instance_student_relations.where(grade: '-').pluck(:credits).sum
    end

    def credits_possible
        self.credits + credits_pending
    end

    def get_gpa
        case self.scholar_year
            when 4..5
                self.gpa_master
            else
                self.gpa_bachelor
        end
    end

    def open_tickets
        self.tickets.where(status: Ticket::OPEN_TICKET)
    end

    def close_tickets
        self.tickets.where(status: Ticket::CLOSE_TICKET)
    end

    def active_projects
        self.projects.where('end >= ?', Date.today)
    end

    def available_projects
        ModuleInstanceActivityRelation.where(module_instance: self.module_instances, is_project: true).where('begin <= ? AND end >= ?', Date.today, Date.today)
    end

    module ClassMethods
        def distinct_promo
            self.select(:promo).distinct.order(:promo).map {|e| e.promo}
        end

        def distinct_cities
            self.select(:location).distinct.order(:location).map {|e| e.location}
        end
    end
end