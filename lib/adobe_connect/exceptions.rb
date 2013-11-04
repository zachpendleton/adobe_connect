module AdobeConnect::Exceptions
  class AdobeConnectServerUnavailable < StandardError
    attr_reader :message
    attr_reader :default_message
    def initialize(subject = nil, action = nil, message = nil)
      @default_message = "The Adobe Connect Service in question was unavailable at the time of request"
      @
    end
    def to_s
      @message || default_message
    end

  end

end
