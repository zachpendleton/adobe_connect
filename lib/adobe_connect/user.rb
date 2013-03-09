module AdobeConnect

  # Public: Represents a user in a Connect environment.
  class User
    # Public: SCO-ID from the Adobe Connect instance.
    attr_reader :id

    # Public: Generic user object.
    attr_reader :app_user

    attr_reader :service, :errors

    # Public: Create a new AdobeConnect User.
    #
    # app_user - A user object with the following methods:
    #            first_name - User's first name.
    #            last_name  - User's last name.
    #            email      - The email address for the user.
    #            uuid       - A unique identifier for this user (used to
    #                          generate a password).
    # service - An AdobeConnect::Service object (default: Service.new)
    def initialize(app_user, service = Service.new)
      @app_user = app_user
      @service  = service
      @errors   = []
    end

    # Public: Getter for the Connect user's username.
    #
    # Returns an email string.
    def username
      app_user.email
    end

    # Public: Generate a password for this connect user.
    #
    # Returns a password string.
    def password
      Digest::MD5.hexdigest(@app_user.uuid)[0..9]
    end

    # Public: Save this user to the Adobe Connect instance.
    #
    # Returns a boolean.
    def save
      response = service.principal_update(:first_name => app_user.first_name,
        :last_name => app_user.last_name, :login => app_user.email,
        :password => password, :type => 'user', :has_children => 0,
        :email => app_user.email)

      if response.at_xpath('//status').attr('code') == 'ok'
        self.id = response.at_xpath('//principal').attr('principal-id')
        true
      else
        save_errors(response)
        false
      end
    end

    # Public: Create a Connect user from the given app user.
    #
    # app_user - A generic user object (see #initialize for required
    #   attributes).
    #
    # Returns an AdobeConnect::User.
    def self.create(app_user)
      user = AdobeConnect::User.new(app_user)
      user.save

      user
    end

    # Public: Find the given app user on the Connect server.
    #
    # app_user - A generic user object (see #initialize for required
    #   attributes).
    #
    # Returns an AdobeConnect::User or nil.
    def self.find(app_user)
      user     = AdobeConnect::User.new(app_user)
      response = user.service.principal_list(:filter_login => user.username)

      if principal = response.at_xpath('//principal')
        user.instance_variable_set(:@id, principal.attr('principal-id'))
        user
      end
    end

    private
    attr_writer :id

    # Internal: Store request errors in @errors.
    #
    # response - An AdobeConnect::Response.
    #
    # Returns nothing.
    def save_errors(response)
      @errors = response.xpath('//invalid').map(&:attributes)
    end
  end
end
