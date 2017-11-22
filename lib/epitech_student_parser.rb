require 'epitech_request'

# These defines are used for netsoul_logs
DAYS_IN_A_MONTH = 31
MONTHS = 3
DAYS_IN_A_WEEK = 7
WEEKS = 4

class EpitechStudentParser
    def initialize(login)
        @login = login
        @request = EpitechRequest.new
        @user_details = @request.get_user_details login
        @user_courses = @request.get_user_courses login
        @user_modules_and_grades = @request.get_user_modules_and_grades login
        @user_netsoul = @request.get_user_netsoul login
        @user_binomes = @request.get_user_binomes login
    end

    # @return [Hash] representing the logs of the student (weekly and monthly)
    def log_netsoul
        result = {}
        @user_netsoul.each do |netsoul_array|
            result[Time.at(netsoul_array[0]).to_date.to_s] = {active_at_school: netsoul_array[1].to_i, promo_average: netsoul_array[5].to_i}
        end

        (1..365).to_a.each do |expected_days|
            date = expected_days.days.ago.to_date.to_s
            next if result[date]
            result[date] = {active_at_school: 0, promo_average: 0}
        end

        result
    end

    # @return [Hash] representing all the modules and grades of a student
    def modules
        @user_modules_and_grades["modules"]
    end

    # @return [Hash] Representing binomes of a students
    def binomes
        @user_binomes
    end

    # @return [Hash]
    def user_details
        user_details_close
        user_details_groups
        @user_details.merge(user_details_gpa).merge(user_details_semester).merge(user_course)
    end

    private

    def user_details_close
        @user_details['close'] = @user_details['close_reason'] if @user_details['close']
        unless @user_details['close']
            @user_details['close'] = nil
            @user_details['close_date'] = nil
        end
    end

    def user_details_groups
        @user_details['groups'] = @user_details['groups'].compact.map {|e| e['title']}
    end

    def user_details_gpa
        result = {}
        @user_details["gpa"].each { |e| result["gpa_" + e["cycle"]] = e["gpa"] } if @user_details["gpa"]
        result
    end

    def user_course
        e = @user_courses['history'].first
        e = {} unless e
        e
    end

    # For some reason Semester.find_by_name could return nil even if the semester exist (cache issue ?)
    def user_details_semester
        s = Semester.find_by_name(@user_details["semester_code"])
        id = nil
        id = s.id if s.present?
        {semester_id: id}
    end
end