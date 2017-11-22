class CourseSemesterModuleRelation < ActiveRecord::Base
    belongs_to :epitech_module
    belongs_to :course_semester_relation
    has_many :courses, through: :course_semester_relation
    has_many :semesters, through: :course_semester_relation
    has_many :schools, through: :courses

    def self.modules_with_unique_semester
        self.group(:epitech_module_id).count.select do |k, v|
            v == 1
        end.map do |k, v|
            k
        end
    end

    def self.detect_strong_semesters_by_year student
        result = {}
        modules_instances_by_year = {}
        student.module_instances.order(:scholar_year).includes(:epitech_module, :semester).each do |module_instance|
            modules_instances_by_year[module_instance.scholar_year] = [] unless modules_instances_by_year[module_instance.scholar_year]
            modules_instances_by_year[module_instance.scholar_year].push(module_instance)
        end
        modules_instances_by_year.each do |year, instances|
            tmp_result = {}
            instances.each do |module_instance|
                semester = module_instance.epitech_module.semester
                is_master = !/[M] -|[M][0-9A-Z] -/.match(module_instance.epitech_module.name).to_s.blank?
                semester = {scholar_year: 'Master'} if is_master
                next unless semester
                tmp_result[semester[:scholar_year]] = 0 unless tmp_result[semester[:scholar_year]]
                tmp_result[semester[:scholar_year]] += 1
            end
            next if tmp_result.empty?
            tmp_result = tmp_result.sort_by{ |key, value| value }
            result[year] = tmp_result.last.first
        end
        result
    end

    def self.find_collision student
        result = $redis.get("student-history-path-#{student.login}")
        return JSON.parse(result).symbolize_keys! if result

        result = {epitech_year: { 1 => [], 2 => [], 3 => [], 'Master' => [] }, active_year: [], nb: 0, first_year: nil, last_year: nil}
        detect_strong_semesters_by_year(student).each do |k, v|
            result[:epitech_year][v] = [] unless result[:epitech_year][v]
            result[:epitech_year][v].push(k)
            result[:active_year].push(k) unless result[:active_year].include?(k)
        end
        result[:epitech_year].each do |k, v|
            if k == "Master" && v.length > 2
                result[:nb] += v.length - 2
            elsif k != "Master" && v.length > 1
                result[:nb] += v.length - 1
            end
        end
        result[:first_year] = result[:active_year].first
        result[:last_year] = result[:active_year].last
        result[:number_of_years] = (result[:first_year]..result[:last_year]).to_a.length
        result[:number_of_years_at_epitech] = (result[:active_year]).length
        result = result.to_json
        $redis.setex "student-history-path-#{student.login}", $redis_default_expiration, result
        JSON.parse(result).symbolize_keys!
    end

    def self.find_pool_collision student
        result = $redis.get("student-history-path-pool-#{student.login}")
        return JSON.parse(result).symbolize_keys! if result

        result = {
            pool_php: student.epitech_modules.where(code: 'B-WEB-250').count,
            pool_c: student.epitech_modules.where(code: 'B-CPE-042-1').count,
            pool_cpp: student.epitech_modules.where(code: 'B-PAV-442-1').count
        }

        result = result.to_json
        $redis.setex "student-history-path-pool-#{student.login}", $redis_default_expiration, result
        JSON.parse(result).symbolize_keys!
    end
end
