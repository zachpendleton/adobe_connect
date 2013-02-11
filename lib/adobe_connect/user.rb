module AdobeConnect
  class User
    attr_reader :id, :app_user, :service, :errors

    def initialize(app_user, service = Service.new)
      @app_user = app_user
      @service  = service
      @errors   = []
    end

    def username
      app_user.email
    end

    def password
      Digest::MD5.hexdigest(@app_user.uuid)[0..9]
    end

    def save
      response = service.principal_update(:first_name => app_user.first_name,
        :last_name => app_user.last_name, :login => app_user.email,
        :password => password, :type => 'user', :has_children => 0,
        :email => app_user.email)

      if response.at_xpath('//status').attr('code') == 'ok'
        true
      else
        save_errors(response)
        false
      end
    end

    def self.create(app_user)
      user = AdobeConnect::User.new(app_user)
      user.save

      user
    end

    def self.find(app_user)
      user     = AdobeConnect::User.new(app_user)
      response = user.service.principal_list(:filter_login => user.username)

      if principal = response.at_xpath('//principal')
        user.instance_variable_set(:@id, principal.attr('principal-id'))
        user
      end
    end

    private
    def save_errors(response)
      @errors = response.xpath('//invalid').map(&:attributes)
    end
  end
end
