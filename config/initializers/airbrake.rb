if Rails.env == 'production'
    Airbrake.configure do |config|
        config.api_key = 'd18bb88091896d4c90d4b0b4a6fa9d6a'
        config.host    = 'errbit.watchdog.int.epitech.eu'
        config.port    = 443
        config.secure  = true
    end
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
