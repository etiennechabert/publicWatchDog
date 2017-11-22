=begin
    READ THIS CARREFULLY !

    Here is the main request class, this is how we execute HTTP request.
    To avoid 'flood' on the Epitech intranet a redis cache is used to save
    the query results.

    Actually the cache validity is set on 31 days (for the dev period)
    If you would like to flush this cache : $> redis-cli FLUSHALL
=end

# noinspection RubyExpressionInStringInspection
class EpitechRequest
    include HTTParty

    class InvalidResponse < Exception
    end

    class NotFound < Exception
    end

    base_uri 'https://intra.epitech.eu'
    default_options.update(verify: false)

    @cookie = nil
    @connection_try = 0

    def self.check_login(user, pass)
        response = self.post('/',
                              body: {
                                  login: user,
                                  password: pass,
                              }
        )
        response.response.class == Net::HTTPOK
    end

    #Fixme: Log en dur ....
    def initialize(user = 'a_user', pass = 'a_password')
        @cookie = $redis.get("cookie-#{user}") if @cookie.nil?
        @user = user

        return unless @cookie.nil?

        response = self.class.get('/')
        # noinspection RubyStringKeysInHashInspection
        response = self.class.post(
                      '/',
                      body: {
                          login: user,
                          password: pass
                      },
                      headers: {
                          'Cookie' => response.headers['Set-Cookie']
                      }
        )
        $redis.setex "cookie-#{user}", $redis_cookie_expiration, response.request.options[:headers]['Cookie']

        @cookie = $redis.get("cookie-#{user}")
    end

    def get_modules_list(scholar_year=nil)
        query_statistics('/admin/module/?format=json')
        base_query = '/admin/module/?format=json'
        base_query += '&scolaryear=' + scholar_year.to_s if scholar_year
        query_exec base_query
    end

    def get_instances_list
        base_url = "https://intra.epitech.eu/course/filter?format=json"
        locations = %w(FR/PAR FR FR/TLS FR/LYN FR/STG FR/REN FR/NCY FR/MAR FR/BDX FR/NAN FR/MPL FR/NCE FR/LIL)
        locations.each do |e|
            next unless e.include?('FR')
            base_url += "&location[]=#{e}"
        end
        base_url
        query_statistics('https://intra.epitech.eu/course/filter?')
        query_exec base_url
    end

    def get_interneships
        query_statistics('/stage/load?format=json')
        query_exec '/stage/load?format=json'
    end

    def get_semesters_list
        query_statistics('/admin/semester?format=json')
        query_exec '/admin/semester?format=json'
    end

    def get_semesters_students_list
        query_statistics('/admin/promo/?format=json')
        query_exec '/admin/promo/?format=json'
    end

    def get_user_details(login)
        query_statistics('/user/#{login}?format=json')
        query_exec "/user/#{login}?format=json"
    end

    def get_user_courses(login)
        query_statistics('/user/#{login}/history/list?format=json')
        query_exec "/user/#{login}/history/list?format=json"
    end

    def get_user_modules_and_grades(login)
        query_statistics('/user/#{login}/notes?format=json')
        query_exec "/user/#{login}/notes?format=json"
    end

    def get_user_netsoul(login)
        query_statistics('/user/#{login}/netsoul?format=json')
        query_exec "/user/#{login}/netsoul?format=json"
    end

    def get_user_binomes(login)
        query_statistics('/user/#{login}/binome?format=json')
        query_exec "/user/#{login}/binome?format=json"
    end

    def get_module_detail(year, code, instance)
        query_statistics('/module/#{year}/#{code}/#{instance}?format=json')
        query_exec "/module/#{year}/#{code}/#{instance}?format=json"
    end

    def get_module_registered(year, code, instance)
        query_statistics('/module/#{year}/#{code}/#{instance}/registered?format=json')
        query_exec "/module/#{year}/#{code}/#{instance}/registered?format=json"
    end

    def get_module_grades(year, code, instance)
        query_statistics('/module/#{year}/#{code}/#{instance}/notes?format=json')
        query_exec "/module/#{year}/#{code}/#{instance}/notes?format=json"
    end

    def get_module_presences(year, code, instance)
        query_statistics('/module/#{year}/#{code}/#{instance}/present?format=json')
        query_exec "/module/#{year}/#{code}/#{instance}/present?format=json"
    end

    def get_activity(year, module_code, module_instance, activity_code)
        query_statistics('/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}')
        query_exec "/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}?format=json"
    end

    def get_activity_grades(year,module_code, module_instance, activity_code)
        query_statistics('/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/note?format=json')
        query_exec "/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/note?format=json"
    end

    def get_activity_groups(year, module_code, module_instance, activity_code)
        query_statistics('/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/project?format=json')
        query_exec "/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/project?format=json"
    end

    def get_event_registered(year, module_code, module_instance, activity_code, event_code)
        query_statistics('/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/#{event_code}/registered?format=json')
        query_exec "/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/#{event_code}/registered?format=json"
    end

    def get_activity_rdv(year, module_code, module_instance, activity_code)
        query_statistics('/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/rdv?format=json')
        query_exec "/module/#{year}/#{module_code}/#{module_instance}/#{activity_code}/project?format=json"
    end

    private

    def query_exec_raise(uri, response)
        return if response.response.class == Net::HTTPOK
        raise NotFound.new(uri) if response.response.class == Net::HTTPNotFound
        raise NotFound.new(uri) if response['error'] == "No module corresponding to your request"
        raise InvalidResponse.new("#{uri} => #{response.to_json}")
    end

    def query_exec_rescue(exception)
        return false if exception.class == NotFound || @connection_try >= 3
        @connection_try += 1
        sleep 1
        true
    end

    def query_exec(uri, expiration = $redis_default_expiration)
        tag = "#{@user}-#{uri}"
        cached_response = $redis.get(tag)
        return JSON.parse(cached_response) unless cached_response.nil?

        @connection_try = 0

        begin
            response = self.class.get(uri, headers: {'Cookie' => @cookie})
            query_exec_raise(uri, response)
        rescue Exception => e
            retry if query_exec_rescue e
            raise e
        end

        $redis.setex tag, expiration, response.to_json

        JSON.parse($redis.get(tag))
    end

=begin
    This function helps us to collect metrics on usage of our request on Epitech Intranet
    By this way we are able to improve the way we are using the cache to avoid useless trafic on intranet
=end
    def query_statistics(format)
        format = "request-statistics-#{format}"
        $redis.setnx(format, 0)
        $redis.incr(format)
    end
end
