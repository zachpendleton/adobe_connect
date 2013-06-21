module AdobeConnect

  # Public: Represents a meeting in a Connect environment.
  class Meeting < Base
    attr_accessor :date_begin, :date_end, :description, :folder_id, :name, :url_path

    #
    # meeting_options - A hash with the following keys:
    #                date_begin  - (optional) Datetime that meeting begins.
    #                date_end    - (optional) Datetime that meeting ends.
    #                description - A description of the meeting to be displayed to users.
    #                folder_id   - (Required for creating) ID of the meeting folder
    #                name        - Name of the meeting
    #                url_path    - (optional) Custom url for meeting. One will be generated
    #                              by AC if not provided
    #

    [ :date_end, :date_begin ].each do |atr|
      define_method atr do
        val = self.instance_variable_get(:"@#{atr.to_s}")
        val.utc.strftime('%Y-%m-%dT%H:%M:%SZ') unless val.nil?
      end
    end

    def attrs
      atrs = {}

      [ :date_end, :date_begin, :description, :name, :url_path ].each do |atr|
        atrs[atr] = send(atr)
      end

      if !self.id.nil?
        atrs.merge!(:sco_id => self.id)
      else
        atrs.merge!(:type => 'meeting', :folder_id => folder_id)
      end

      atrs
    end

    def self.config
      super.merge({ :ac_obj_type => 'sco' })
    end

    def self.find_by_url_path(url_path, service = AdobeConnect::Service.new)
      response = service.sco_by_url(:url_path => url_path)

      ac_meeting = response.at_xpath('//sco')

      m = self.new({}, service)

      m.attrs.each do |atr,v|
        chld = ac_meeting.at_xpath("//#{atr.to_s.dasherize}")
        if !chld.nil?
          send(atr, chld.text)
        end
      end

      m.folder_id = ac_meeting.attr('folder-id')
      m.instance_variable_set(:@id, ac_meeting.attr('sco-id'))
    end

  end
end
