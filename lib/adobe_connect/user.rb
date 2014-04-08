module AdobeConnect

  # Public: Represents a user in a Connect environment.
  class User < Base
    attr_accessor :first_name, :last_name, :email, :username, :uuid, :send_email

    #
    # user_options - A hash with the following keys:
    #                first_name - User's first name.
    #                last_name  - User's last name.
    #                email      - The email address for the user.
    #                username   - The login for the connect user.
    #                uuid       - A unique identifier for this user (used to
    #                             generate a password).
    #                send_email - The server sends a welcome e-mail with login information
    #                             to the user’s e-mail address.
    #

    def attrs
      atrs = { :first_name => first_name,
        :last_name => last_name, :login => username,
        :email => email, :send_email => send_email,
        :has_children => 0 }
      if !self.id.nil?
        atrs.merge!(:principal_id => self.id)
      else
        atrs.merge!(
          :password => password,
          :type => 'user'
        )
      end
      atrs
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

    # Public: Find the given app user on the Connect server.
    #
    # app_user - Generic user options (see #initialize for required
    #   attributes).
    #
    # Returns an AdobeConnect::User or nil.
    def self.find(user_options, service = AdobeConnect::Service.new)
      user     = AdobeConnect::User.new(user_options, service)
      response = user.service.principal_list(:filter_login => user.username)

      if principal = response.at_xpath('//principal')
        user.instance_variable_set(:@id, principal.attr('principal-id'))
        user
      end
    end
  end
end
