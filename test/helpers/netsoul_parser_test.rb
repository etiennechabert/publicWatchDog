require 'test_helper'

# [TIMESTAMP, SCHOOL_ACTIVE, SCHOOL_IDLE, AWAY_ACTIVE, AWAY_IDLE, PROMO_AVERAGE]
class NetsoulParserTest < ActiveSupport::TestCase
    def logs_model
        [0,1,2,3,4,5]
    end

    def generate_logs(days)
        result = []
        (1..days).each do |day|
            element = logs_model
            element[0] = Date.today.days_ago(day).to_time.to_i
            result.push(element)
        end
        result
    end

    test 'basic_netsoul_check' do
        student = EpitechStudentParser.new('chaber_e')
        student.log_netsoul(generate_logs(31))
    end
end