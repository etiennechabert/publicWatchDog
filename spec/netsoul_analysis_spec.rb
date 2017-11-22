require 'rails_helper'
#require 'spec_helper'
#require 'rails/rack/debugger'
require 'netsoul_analysis'

MINUTE = 60
HOURS = MINUTE * 60

STUDENT_ERROR = {}

STUDENT_GHOST = {
    "log_time_week_1"=>"{\"date_from\":\"2015-02-22\",\"date_to\":\"2015-02-28\",\"school_active\":0,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_2"=>"{\"date_from\":\"2015-02-15\",\"date_to\":\"2015-02-21\",\"school_active\":0,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_3"=>"{\"date_from\":\"2015-02-08\",\"date_to\":\"2015-02-14\",\"school_active\":1,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_4"=>"{\"date_from\":\"2015-02-01\",\"date_to\":\"2015-02-07\",\"school_active\":0,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_1"=>"{\"date_from\":\"2015-01-29\",\"date_to\":\"2015-02-28\",\"school_active\":0,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_2"=>"{\"date_from\":\"2014-12-29\",\"date_to\":\"2015-01-28\",\"school_active\":0,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_3"=>"{\"date_from\":\"2014-11-28\",\"date_to\":\"2014-12-28\",\"school_active\":0,\"school_idle\":0,\"away_active\":0,\"away_idle\":0}"
}

STUDENT_USUAL = {
    "log_time_week_1"=>"{\"date_from\":\"2015-02-22\",\"date_to\":\"2015-02-28\",\"school_active\":#{HOURS * 40},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_2"=>"{\"date_from\":\"2015-02-15\",\"date_to\":\"2015-02-21\",\"school_active\":#{HOURS * 40 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_3"=>"{\"date_from\":\"2015-02-08\",\"date_to\":\"2015-02-14\",\"school_active\":#{HOURS * 40},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_4"=>"{\"date_from\":\"2015-02-01\",\"date_to\":\"2015-02-07\",\"school_active\":#{HOURS * 40},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_1"=>"{\"date_from\":\"2015-01-29\",\"date_to\":\"2015-02-28\",\"school_active\":#{HOURS * 40 * 4},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_2"=>"{\"date_from\":\"2014-12-29\",\"date_to\":\"2015-01-28\",\"school_active\":#{HOURS * 40 * 4 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_3"=>"{\"date_from\":\"2014-11-28\",\"date_to\":\"2014-12-28\",\"school_active\":#{HOURS * 40 * 4},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}"
}

STUDENT_GOOD = {
    "log_time_week_1"=>"{\"date_from\":\"2015-02-22\",\"date_to\":\"2015-02-28\",\"school_active\":#{HOURS * 40 * 2 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_2"=>"{\"date_from\":\"2015-02-15\",\"date_to\":\"2015-02-21\",\"school_active\":#{HOURS * 40 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_3"=>"{\"date_from\":\"2015-02-08\",\"date_to\":\"2015-02-14\",\"school_active\":#{HOURS * 40 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_week_4"=>"{\"date_from\":\"2015-02-01\",\"date_to\":\"2015-02-07\",\"school_active\":#{HOURS * 40 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_1"=>"{\"date_from\":\"2015-01-29\",\"date_to\":\"2015-02-28\",\"school_active\":#{HOURS * 40 * 4 * 2 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_2"=>"{\"date_from\":\"2014-12-29\",\"date_to\":\"2015-01-28\",\"school_active\":#{HOURS * 40 * 4 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}",
    "log_time_month_3"=>"{\"date_from\":\"2014-11-28\",\"date_to\":\"2014-12-28\",\"school_active\":#{HOURS * 40 * 4 * 2},\"school_idle\":0,\"away_active\":0,\"away_idle\":0}"
}



describe 'netsoul_analysis' do
    it 'Should check parameters for CTOR' do
        expect{NetsoulAnalysis.new(STUDENT_ERROR.clone)}.to raise_error
        expect{NetsoulAnalysis.new(STUDENT_USUAL.clone)}.to_not raise_error
    end

    it 'Check the presence value for STUDENT_GHOST' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GHOST.clone)

        expect(netsoul_analysis.presence_value('log_time_week_1', 'school_active')).to eql 0.0
        expect(netsoul_analysis.presence_value('log_time_month_1', 'school_active')).to eql 0.0
    end

    it 'Check the presence value  for STUDENT_USUAL' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_USUAL.clone)

        expect(netsoul_analysis.presence_value('log_time_week_1', 'school_active')).to eql 1.0
        expect(netsoul_analysis.presence_value('log_time_month_1', 'school_active')).to eql 1.0
    end

    it 'Check the presence value for STUDENT_GOOD' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GOOD.clone)

        expect(netsoul_analysis.presence_value('log_time_week_1', 'school_active')).to eql 4.0
        expect(netsoul_analysis.presence_value('log_time_month_1', 'school_active')).to eql 4.0
    end

    it 'Check the evolution value for STUDENT_GHOST' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GHOST.clone)

        # Nul evolution = 0.1
        expect(netsoul_analysis.evolution_value('log_time_week_1', 'log_time_week_2', 'school_active')).to eql 0.1
        # Infinite evolution = 2
        expect(netsoul_analysis.evolution_value('log_time_week_3', 'log_time_week_4', 'school_active')).to eql 2.0
    end

    it 'Check the evolution value for STUDENT_USUAL' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_USUAL.clone)

        expect(netsoul_analysis.evolution_value('log_time_week_1', 'log_time_week_2', 'school_active')).to eql 0.5
        expect(netsoul_analysis.evolution_value('log_time_month_1', 'log_time_month_2', 'school_active')).to eql 0.5
        expect(netsoul_analysis.evolution_value('log_time_week_3', 'log_time_week_4', 'school_active')).to eql 1.0
        expect(netsoul_analysis.evolution_value('log_time_month_1', 'log_time_month_3', 'school_active')).to eql 1.0
    end

    it 'Check the evolution value for STUDENT_GOOD' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GOOD.clone)

        expect(netsoul_analysis.evolution_value('log_time_week_1', 'log_time_week_2', 'school_active')).to eql 2.0
        expect(netsoul_analysis.evolution_value('log_time_month_1', 'log_time_month_2', 'school_active')).to eql 2.0
    end

    it 'Check the general value for STUDENT_GHOST' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GHOST.clone)

        expect(netsoul_analysis.general_value('log_time_week_1', 'log_time_week_2', 'school_active')).to eql 0.0
        expect(netsoul_analysis.general_value('log_time_month_1', 'log_time_month_2', 'school_active')).to eql 0.0
    end

    it 'Check the general value for STUDENT_USUAL' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_USUAL.clone)

        expect(netsoul_analysis.general_value('log_time_week_1', 'log_time_week_2', 'school_active')).to eql 0.5
        expect(netsoul_analysis.general_value('log_time_month_1', 'log_time_month_2', 'school_active')).to eql 0.5
    end

    it 'Check the general value for STUDENT_GOOD' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GOOD.clone)

        expect(netsoul_analysis.general_value('log_time_week_1', 'log_time_week_2', 'school_active')).to eql 8.0
        expect(netsoul_analysis.general_value('log_time_month_1', 'log_time_month_2', 'school_active')).to eql 8.0
    end

    it 'Check the final value for STUDENT_GHOST' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GHOST.clone)

        expect(netsoul_analysis.final_value).to eql 0.0
        expect(netsoul_analysis.final_value).to eql 0.0
    end

    it 'Check the final value for STUDENT_USUAL' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_USUAL.clone)

        expect(netsoul_analysis.final_value).to eql 0.5
        expect(netsoul_analysis.final_value).to eql 0.5
    end

    it 'Check the final value for STUDENT_GOOD' do
        netsoul_analysis = NetsoulAnalysis.new(STUDENT_GOOD.clone)

        expect(netsoul_analysis.final_value).to eql 8.0
        expect(netsoul_analysis.final_value).to eql 8.0
    end
end