module Devise
    module Strategies
        class RemoteAuthenticatable < Authenticatable
            #
            # For an example check : https://github.com/plataformatec/devise/blob/master/lib/devise/strategies/database_authenticatable.rb
            #
            # Method called by warden to authenticate a resource.
            #
            def authenticate!
                auth_params = authentication_hash
                auth_params[:password] = password

                resource = User.find_by_login(auth_params[:login])
                resource = mapping.to.new(auth_params) unless resource

                return fail! unless resource

                return fail!(:not_found_in_database) unless (
                    validate(resource) { resource.local_authentication(auth_params[:password]) } ||
                    validate(resource) { resource.remote_authentication(auth_params[:password]) }
                )

                if resource.check_allowed
                    valid_authenticate(resource)
                else
                    fail!(:not_allowed)
                end
            end


            def valid_authenticate(resource)
                remember_me(resource)
                success!(resource)
            end
        end
    end
end
