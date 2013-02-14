module AdobeConnect

  # Public: A response from the Connect API.
  class Response
    attr_reader :status, :body

    # Public: Create a new AdobeConnect::Response.
    #
    # response - A Net::HTTP response.
    def initialize(response)
      @response = response
      @status   = response.code.to_i
      @body     = Nokogiri::XML(response.body)
    end

    # Public: Fetch the given header's value.
    #
    # header - The string name of the header to fetch.
    #
    # Returns a header value as a string.
    def fetch(header)
      @response.fetch(header)
    end

    # Public: Execute an xpath call against the response body.
    #
    # *args - Arguments to pass to Nokogiri's xpath method.
    #
    # Returns a Nokogiri object.
    def xpath(*args)
      @body.xpath(*args)
    end

    # Public: Execute an at_xpath call against the response body.
    #
    # *args - Arguments to pass to Nokogiri's xpath method.
    #
    # Returns a Nokogiri object.
    def at_xpath(*args)
      @body.at_xpath(*args)
    end
  end
end
