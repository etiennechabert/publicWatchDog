class SerializedException < ActiveRecord::Base

    IGNORED_EXCEPTION = ['Mysql2', 'Operation timed out', 'Validation failed', 'Connection refused']

    before_create :check_ignore

    private
    def check_ignore
        IGNORED_EXCEPTION.each do |ignore_case|
            return false if self.exception_message.include? ignore_case
        end

        true
    end
end
