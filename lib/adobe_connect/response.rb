module AdobeConnect
  class Response
    attr_reader :status, :body

    def initialize(response)
      @response = response
      @status   = response.status
      @body     = Nokogiri::XML(response.body)
    end

    def fetch(header)
      @response.fetch(header)
    end

    def xpath(*args)
      @body.xpath(*args)
    end

    def at_xpath(*args)
      @body.at_xpath(*args)
    end
  end
end
