require 'delegate'

module AdobeConnect

  # Public: A response from the Connect API.
  class Response < SimpleDelegator
    attr_reader :status, :body

    # Public: Create a new AdobeConnect::Response.
    #
    # response - A Net::HTTP response.
    def initialize(response)
      @response = response
      @status   = response.code.to_i
      @body     = Nokogiri::XML(response.body)

      __setobj__(@body)
    end

    # Public: Fetch the given header's value.
    #
    # header - The string name of the header to fetch.
    #
    # Returns a header value as a string.
    def fetch(header)
      @response.fetch(header)
    end
  end
end
