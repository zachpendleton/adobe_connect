module AdobeConnect

  class AdobeConnect::Exception < StandardError
  end

  class ServerUnavailableError < AdobeConnect::Exception
    attr_reader :message
    def initialize(subject = nil, action = nil, message = nil)
      @default_message = "The Adobe Connect Service in question was unavailable at the time of request"
    end
    def to_s
      @message || @default_message
    end

  end

end
