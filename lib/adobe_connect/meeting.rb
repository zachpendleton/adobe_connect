module AdobeConnect

  # Public: Represents a meeting in a Connect environment.
  class Meeting < Base
    attr_accessor :description, :folder_id, :name, :url_path

    #
    # meeting_options - A hash with the following keys:
    #                description - A description of the meeting to be displayed to users.
    #                folder_id   - (Required for creating) ID of the meeting folder
    #                name        - Name of the meeting
    #                url_path    - (optional) Custom url for meeting. One will be generated
    #                              by AC if not provided
    #

    def attrs
      atrs = {}

      [ :description, :name, :url_path ].each do |atr|
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

  end
end
