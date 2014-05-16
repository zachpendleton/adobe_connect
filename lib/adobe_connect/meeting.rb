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
    def attrs
      atrs = {:type => 'meeting'}

      [ :date_end, :date_begin, :description, :name, :url_path ].each do |atr|
        atrs[atr] = send(atr)
      end

      if !self.id.nil?
        atrs.merge!(:sco_id => self.id)
      else
        atrs.merge!(:folder_id => folder_id)
      end

      atrs
    end

    def add_host(principal_id)
      permissions_update(principal_id, 'host')
    end

    def add_presenter(principal_id)
      permissions_update(principal_id, 'mini-host')
    end

    def add_participant(principal_id)
      permissions_update(principal_id, 'view')
    end

    def remove_user(principal_id)
      permissions_update(principal_id, 'remove')
    end

    def self.config
      super.merge({ :ac_obj_type => 'sco', :delete_method_is_plural => false })
    end

    def self.find_by_id(sco_id, service = AdobeConnect::Service.new)
      response = service.sco_info(sco_id: sco_id)
      sco_info = response.at_xpath('//sco')

      if !sco_info.nil?
        load_from_xml(sco_info, service)
      else
        nil
      end
    end

    def self.find_by_url_path(url_path, service = AdobeConnect::Service.new)
      response = service.sco_by_url(:url_path => url_path)

      ac_meeting = response.at_xpath('//sco')

      if !ac_meeting.nil?
        load_from_xml(ac_meeting, service)
      else
        nil
      end
    end

    def self.find_within_folder(folder_id, params = {}, service = AdobeConnect::Service.new)
      response = service.sco_contents( params.merge(:sco_id => folder_id, :type => 'meeting') )
      ac_meetings = response.at_xpath('//scos')
      meetings = ac_meetings.children.map{|m| load_from_xml(m, service) }
    end

    private
    def self.load_from_xml(ac_meeting, service)
      meeting = self.new({}, service)

      meeting.attrs.each do |atr,v|
        chld = ac_meeting.children.select{|c| c.name == atr.to_s.dasherize}[0]
        if !chld.nil?
          meeting.send(:"#{atr}=", chld.text)
        end
      end

      meeting.folder_id = ac_meeting.attr('folder-id')
      meeting.instance_variable_set(:@id, ac_meeting.attr('sco-id'))

      meeting
    end
  end
end
