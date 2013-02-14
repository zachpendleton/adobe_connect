module AdobeConnect

  # Public: Responsible for translating params hashes into query strings 
  class ParamFormatter
    attr_reader :params

    # Public: Create a new AdobeConnect::ParamFormatter.
    #
    # params - A hash of params to format.
    def initialize(params)
      @params = params
    end

    # Public: Translate a hash of params into a query string. Dasherize any
    # underscored values, and escape URL unfriendly values.
    #
    # Returns a query string.
    def format
      params.sort_by { |k, v| k.to_s }.inject(['']) do |array, param|
        key, value = param.map { |p| ERB::Util.url_encode(p) }
        array << "#{key.dasherize}=#{value}"
      end.join('&')
    end
  end
end
