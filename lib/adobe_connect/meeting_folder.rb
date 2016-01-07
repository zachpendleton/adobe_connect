module AdobeConnect

  # Public: Represents a folder object inside of Connect.
  class MeetingFolder
    attr_reader :name, :id, :service, :url

    # Public: Create a new AdobeConnect::MeetingFolder.
    #
    # id      - The SCO-ID of the folder object.
    # name    - The name of the folder object.
    # url     - The Connect URL of the object.
    # service - An AdobeConnect::Service object (default: Service.new).
    def initialize(id, name, url, service = AdobeConnect::Service.new)
      @name    = name
      @id      = id
      @service = service
      @url     = url
    end

    # Public: Fetch the contents of this folder.
    #
    # Returns a Nokogiri object.
    def contents
      service.sco_contents(:sco_id => id)
    end

    # Public: Find a folder on the current Connect instance.
    #
    # name - The name of the folder to find.
    # service - An AdobeConnect::Service object (default: Service.new).
    #
    # Returns a new AdobeConnect::MeetingFolder object.
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

    # Public: Find the "My Meetings" folder ID of the currently logged in User
    #
    # service - An AdobeConnect::Service object (default: Service.new).
    #
    # Returns a string of the sco ID of the folder
    def self.my_meetings_folder_id(service = AdobeConnect::Service.new)
      response = service.sco_shortcuts({})
      folder = response.at_xpath('//shortcuts').children.select{|s|
        s.attr('type') == 'my-meetings'
      }[0]
      if folder.nil?
        nil
      else
        folder.attr('sco-id')
      end
    end
  end
end
