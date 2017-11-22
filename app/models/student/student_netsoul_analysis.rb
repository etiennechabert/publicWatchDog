module Student::StudentNetsoulAnalysis
    extend ActiveSupport::Concern

    module ClassMethods
        def promo_netsoul(promo_id, attribute_key, user=nil)
            result = {school_active: 0, school_idle: 0, away_active: 0, away_idle: 0}
            if user
                students = user.students
            else
                students = Student.all
            end
            students.where(promo_id: promo_id).where.not(attribute_key => nil).each do |student|
                tmp_data = JSON.parse student[attribute_key]
                result.each do |k, v|
                    result[k] += tmp_data[k.to_s]
                end
            end
            students_count = students.where(promo_id: promo_id).count
            result.each do |k, v|
                result[k] /= students_count
            end
            result
        end
    end
end