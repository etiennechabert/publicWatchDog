SECONDS_PER_MINUTE = 60
MINUTES_PER_HOURS = 60
HOURS_PER_DAY = 24
REDIS_PASSWORD = 'hBdqVBa5dLRZkYHYlpmkfnK6N6cPpWPHPXMPA4q6Y9cKhZucilrD3GfxOG47rqOvvioueI9YpMyjQFHjBJ1o7odlPFZDq2Iby4ZggwZnvYiq8VBiYmEqnZ94HZvTDXfoEL3Rnc9rcjLrikscvYahQuQ5GiU7RKIkPu4EiAPdqzfS593TLZRaBIQseMjpmTgbbFv69eGLXFv0xLdfdqN4yNrVyEvC74h7MTVKLmqTRGXAny9vBSblgPp0MRlW790P2rsYmDiifYOzyN0FUHIsnPx060AXH9xPGvJrQXUtTuoxmxQSvzLYN4uIfBLmSZfknQu0m03cua8jZwnhiVe9pGXR0BhkyARrluiyEGKt0DmqBO7hWe99h4PuYqSLzFQoebskzc60lFET2H8uyGgR2Kx46KZccWTLxykHQ6hp82Fmvndr9TT2onEILRe3zFjxAO2G9vdXiTgz56WMemoblvdgBdDQmvz0kzSJ4CMHUhtZT0qNmR8SLAnFORVC8wSa'

$redis = Redis.new(password: REDIS_PASSWORD)

# This hook allow us to use the same code for production and dev (in production a password is enable on the redis server)
begin
    $redis.keys
rescue Exception
    $redis = Redis.new
end

# 1 month expiration (developement)
$redis_default_expiration = SECONDS_PER_MINUTE * MINUTES_PER_HOURS * HOURS_PER_DAY

# 1 hour expiration
$redis_cookie_expiration = SECONDS_PER_MINUTE * MINUTES_PER_HOURS