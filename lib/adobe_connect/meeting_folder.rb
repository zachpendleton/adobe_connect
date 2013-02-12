module AdobeConnect
  class MeetingFolder
    attr_reader :name, :id, :service, :url

    def initialize(id, name, url, service = AdobeConnect::Service.new)
      @name    = name
      @id      = id
      @service = service
      @url     = url
    end

    def contents
      service.sco_contents(:sco_id => id)
    end

    def self.find(name, service = AdobeConnect::Service.new)
      response = service.sco_search_by_field(
        :query       => name,
        :filter_type => 'folder',
        :field       => 'name')

      MeetingFolder.new(response.at_xpath('//sco').attr('sco-id'),
        response.at_xpath('//name').text,
        response.at_xpath('//url-path').text,
        service)
    end
  end
end
