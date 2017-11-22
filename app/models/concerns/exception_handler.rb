module ExceptionHandler
    extend ActiveSupport::Concern

    # @param [Error] exception
    def handleException(instance, exception)
        SerializedException.create({
                                       class_name: instance.class,
                                       exception_class: exception.class,
                                       exception_message: exception.to_s,
                                       serialized_instance: readable_json(instance.to_json),
                                       serialized_stack: readable_json(exception.backtrace.to_json)
                                   })
        invalid_cache
        mark_as_not_refresh
        raise exception if Rails.env.test?
    end

    def invalid_cache
        keys = $redis.keys(self.redis_keys)
        $redis.del(keys) unless keys.empty?
    end

    private

    def readable_json(element)
        element.gsub(",", ",\n")
    end
end