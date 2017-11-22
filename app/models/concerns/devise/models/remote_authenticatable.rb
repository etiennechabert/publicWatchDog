require 'bcrypt'

module Devise
    module Models
        module RemoteAuthenticatable
            INTRA_CREDITENTIAL_VALIDITY = 7

            extend ActiveSupport::Concern

            #
            # Here you do the request to the external webservice
            #
            # If the authentication is successful you should return
            # a resource instance
            #
            # If the authentication fails you should return false
            #

            def local_authentication(password)
                user = User.find_by_login(self.login) # Check if user exist and password match else we do a remote auth
                return false unless user
                return false unless user.check_password(password)
                return false unless self.check_allowed # We check that user is allowed to access the website
                true if self.last_intra_check >= Date.today - INTRA_CREDITENTIAL_VALIDITY && self.password == password # If password was matching we check the last intra_check
            end

            def remote_authentication(password)
                return false unless EpitechRequest.check_login(self.login, password)
                self.password = password
                self.store_epitech_groups
                self.update_attributes({last_intra_check: Date.today})
                true
            end

            def check_permission
                self.check_allowed
            end

            module ClassMethods
                ####################################
                # Overriden methods from Devise::Models::Authenticatable
                ####################################

                #
                # This method is called from:
                # Warden::SessionSerializer in devise
                #
                # It takes as many params as elements had the array
                # returned in serialize_into_session
                #
                # Recreates a resource from session data
                #
                def serialize_from_session(id, login)
                    self.find_by_login(login)
                end

                #
                # Here you have to return and array with the data of your resource
                # that you want to serialize into the session
                #
                # You might want to include some authentication data
                #
                def serialize_into_session(record)
                    record.save if record.id.blank?
                    [record.id, record.login]
                end
            end
        end
    end
end