module ApplicationHelper
    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    ###### DATE AND TIME HELPERS ######

    def int_to_duration(value)
        hours = value / 60 / 60
        minutes = value / 60 % 60
        seconds = value % 60
        "#{hours.round(0)} H #{minutes.round(0)}"
    end

    def time_ago(datetime, detailed=false)
        return 'Never' unless datetime
        ret = time_ago_in_words(datetime)
        ret = ret.split(',').first unless detailed
        ret
    end

    def days_ago(date)
        return 'Never' unless date
        date = date.to_date unless date.class == Date
        (Date.today - date).to_i.to_s
    end

    def days_left(date)
        return 'Never' unless date
        date = date.to_date unless date.class == Date
        (date - Date.today).to_i.to_s
    end
end
