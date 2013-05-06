module AdobeConnect

  # Public: Represents a user in a Connect environment.
  class User
    # Public: SCO-ID from the Adobe Connect instance.
    attr_reader :id

    attr_reader :service, :errors
    attr_accessor :first_name, :last_name, :email, :username, :uuid

    # Public: Create a new AdobeConnect User.
    #
    # user_options - A hash with the following keys:
    #                first_name - User's first name.
    #                last_name  - User's last name.
    #                email      - The email address for the user.
    #                uuid       - A unique identifier for this user (used to
    #                             generate a password).
    # service - An AdobeConnect::Service object (default: Service.new)
    def initialize(user_options, service = Service.new)
      user_options.each { |key, value| send(:"#{key}=", value) }
      @service  = service
      @errors   = []
    end

    # Public: Getter for the Connect user's username. If no username is
    #   given, use the email.
    #
    # Returns a username string.
    def username
      @username || email
    end

    # Public: Generate a password for this connect user.
    #
    # Returns a password string.
    def password
      Digest::MD5.hexdigest(uuid)[0..9]
    end

    # Public: Save this user to the Adobe Connect instance.
    #
    # Returns a boolean.
    def save
      response = service.principal_update(:first_name => first_name,
        :last_name => last_name, :login => username,
        :password => password, :type => 'user', :has_children => 0,
        :email => email)

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
    # user_options - Generic user options (see #initialize for required
    #   attributes).
    #
    # Returns an AdobeConnect::User.
    def self.create(user_options)
      user = AdobeConnect::User.new(user_options)
      user.save

      user
    end

    # Public: Find the given app user on the Connect server.
    #
    # app_user - Generic user options (see #initialize for required
    #   attributes).
    #
    # Returns an AdobeConnect::User or nil.
    def self.find(user_options)
      user     = AdobeConnect::User.new(user_options)
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
