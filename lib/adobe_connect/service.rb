module AdobeConnect

  # Public: Manages calls to the Connect API.
  class Service
    attr_reader :username, :domain, :session

    # Public: Create a new AdobeConnect::Service.
    #
    # options - An AdobeConnect::Config object or a hash with the keys:
    #           :username - An Adobe Connect username.
    #           :password - The Connect user's password.
    #           :domain   - The domain for the Connect instance (with protocol
    #                       prepended).
    def initialize(options = AdobeConnect::Config)
      @username      = options[:username]
      @password      = options[:password]
      @domain        = URI.parse(options[:domain])
      @authenticated = false
    end

    # Public: Authenticate against the currently configured Connect service.
    #
    # Returns a boolean.
    def log_in
      response = request('login', { :login => username, :password => password }, false)
      if response.at_xpath('//status').attr('code') == 'ok'
        session_regex  = /BREEZESESSION=([^;]+)/
        @session       = response.fetch('set-cookie').match(session_regex)[1]
        @authenticated = true
      else
        false
      end
    end

    # Public: Get the current authentication status.
    #
    # Returns a boolean.
    def authenticated?
      @authenticated
    end

    # Public: Get the HTTP client used to make requests.
    #
    # Returns a Net::HTTP instance.
    def client
      if @client.nil?
        @client         = Net::HTTP.new(domain.host, domain.port)
        @client.use_ssl = (domain.scheme == 'https')
      end

      @client
    end

    # Public: Forward any missing methods to the Connect instance.
    #
    # method - The name of the method called.
    # *args  - An array of arguments passed to the method.
    #
    # Examples
    #
    #   service = AdobeConnect::Service.new
    #   service.sco_by_url(url_path: '/example/') #=> calls service.request.
    #
    # Returns an AdobeConnect::Response.
    def method_missing(method, *args)
      action = method.to_s.dasherize
      params = args.first

      request(action, params)
    end

    private
    attr_reader :password

    # Public: Execute a call against the Adobe Connect instance.
    #
    # action      - The name of the API action to call.
    # params      - A hash of params to pass in the request.
    # use_session - If true, require an active session (default: true).
    #
    # Returns an AdobeConnect::Response.
    def request(action, params, use_session = true)
      if use_session
        log_in unless authenticated?
        params[:session] = session
      end

      query_string = ParamFormatter.new(params).format
      response     = client.get("/api/xml?action=#{action}#{query_string}")
      AdobeConnect::Response.new(response)
    end
  end
end
