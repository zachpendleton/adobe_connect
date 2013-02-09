module AdobeConnect
  class User
    attr_reader :id, :canvas_user, :service, :errors

    def initialize(canvas_user, service = Service.new)
      @canvas_user = canvas_user
      @service     = service
      @errors      = []
    end

    def username
      canvas_user.email
    end

    def password
      Digest::MD5.hexdigest(@canvas_user.uuid)[0..9]
    end

    def save
      response = service.principal_update(first_name: canvas_user.first_name,
        last_name: canvas_user.last_name, login: canvas_user.email,
        password: password, type: 'user', has_children: 0,
        email: canvas_user.email)

      body = Nokogiri::XML(response.body)

      if body.at_xpath('//status').attr('code') == 'ok'
        true
      else
        save_errors(body)
        false
      end
    end

    def self.create(canvas_user)
      user = AdobeConnect::User.new(canvas_user)
      user.save

      user
    end

    def self.find(canvas_user)
      user     = AdobeConnect::User.new(canvas_user)
      response = user.service.principal_list(filter_login: user.username)

      if principal = Nokogiri::XML(response.body).at_xpath('//principal')
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
