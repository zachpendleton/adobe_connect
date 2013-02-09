module AdobeConnect
  class Session
    attr_reader :service, :user

    def initialize(user, service = Service.new)
      @user    = user
      @service = service
    end

    def key
      unless key
        service.log_in
        @key = service.session
      end

      key
    end
  end
end
