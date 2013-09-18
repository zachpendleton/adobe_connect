module AdobeConnect

  # Public: Represents a Group in a Connect environment.
  class TelephonyProfile < Base
    attr_accessor :conf_number, :location, :principal_id,
      :name, :status, :provider_id

    #
    # telephony_profile_options - A hash with the following keys:
    #                name        - The profile's name.
    #                status      - Status of the profile (enabled or disabled)
    #                conf_number - Conference number associated with profile
    #                location    - Country code for conference number, required
    #                              if conf_number present
    #                principal_id- ID of User that the profile should belong
    #                              to, defaults to logged in user
    #                provider_id - ID of the telephony provider
    #

    def attrs
      atrs = { :profile_name => self.name }

      if !self.id.nil?
        atrs.merge!(:profile_id => self.id)
      end

      [:id, :status].each do |atr|
        if !self.send(atr).nil?
          atrs.merge!("profile_#{atr}".to_sym => self.send(atr))
        end
      end

      [:principal_id, :provider_id].each do |atr|
        if !self.send(atr).nil?
          atrs.merge!(atr => self.send(atr))
        end
      end

      if !self.conf_number.nil? && !self.location.nil?
        atrs.merge!(:conf_number => self.conf_number, :location => self.location)
      end

      atrs
    end

    def self.config
      super.merge({ :ac_obj_type => 'profile', :delete_method_is_plural => false,
        :ac_obj_node_name => 'telephony-profile', :ac_method_prefix => 'telephony_profile' })
    end

    # Public: Find the specified profile on the Connect server.
    #
    # name - Profile's name on Connect server
    # principal_id - ID of user on Connect server that the Telephony
    #                Profile belongs to. Will use API user by default.
    #
    # Returns an AdobeConnect::TelephonyProfile or nil.
    def self.find_by_name(name, principal_id = nil, service = AdobeConnect::Service.new)
      params = {}
      params.merge!(:principal_id => principal_id) unless principal_id.nil?

      response = service.telephony_profile_list(params)

      matching_profiles = response.at_xpath('//telephony-profiles').children.select{|c|
        name_node = c.children.select{|ch| ch.name == 'profile-name' }[0]
        name_node.text == name
      }

      if matching_profiles.count == 1
        prof_id = matching_profiles[0].attr('profile-id')
        resp = service.telephony_profile_info(:profile_id => prof_id)
        self.load_from_xml(resp.at_xpath('//telephony-profile'), principal_id)
      end
    end

    private
    def self.load_from_xml(p, principal_id)
      self.new({
          :name => p.at_xpath('//profile-name').text,
          :id => p.attr('profile-id'),
          :status => p.attr('profile-status'),
          :principal_id => principal_id,
          :provider_id => p.attr('provider-id')
        })
    end
  end
end
