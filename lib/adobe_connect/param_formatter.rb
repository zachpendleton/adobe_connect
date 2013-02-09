module AdobeConnect
  class ParamFormatter
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def format
      params.inject(['']) do |array, param|
        key, value = param.map { |p| ERB::Util.url_encode(p) }
        array << "#{key.dasherize}=#{value}"
      end.join('&')
    end
  end
end
