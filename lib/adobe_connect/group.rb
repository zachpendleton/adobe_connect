module AdobeConnect

  # Public: Represents a Group in a Connect environment.
  class Group < Base
    attr_accessor :description, :name, :id

    #
    # group_options - A hash with the following keys:
    #                name        - The group’s name.
    #                description - The group's description
    #

    def attrs
      atrs = { :has_children => 1, :name => name, :description => description }

      if !self.id.nil?
        atrs.merge!(:principal_id => self.id)
      else
        atrs.merge!(
          :type => 'group'
        )
      end
      atrs
    end

    # Public: Add a User as a member of this group.
    #
    # user - AdobeConnect::User instance
    #
    # Returns a boolean of success.
    def add_member(user)
      update_membership(user, true)
    end

    # Public: Find the member of this group.
    #
    # email - User's email address
    #
    # Returns a boolean.
    def is_member?(email)
      return false if self.id.nil?

      response = service.principal_list(:group_id => self.id,
        :filter_email => email,
        :filter_is_member => true)

      !response.at_xpath('//principal').nil?
    end

    # Public: Remove a User from this group.
    #
    # user - AdobeConnect::User instance
    #
    # Returns a boolean of success.
    def remove_member(user)
      update_membership(user, false)
    end

    # Public: Find the given group on the Connect server.
    #
    # name - Group's name on Connect server
    #
    # Returns an AdobeConnect::Group or nil.
    def self.find_by_name(name, service = AdobeConnect::Service.new)
      response = service.principal_list(:filter_name => name)

      if principal = response.at_xpath('//principal')
        self.load_from_xml(principal)
      end
    end

    private
    def update_membership(user, status)
      response = service.group_membership_update({
          :group_id => self.id,
          :principal_id => user.id,
          :is_member => status
        })

      response.at_xpath('//status').attr('code') == 'ok'
    end

    def self.load_from_xml(g)
      desc = g.at_xpath('//description')
      desc = desc.children unless desc.nil?
      desc = desc.text unless desc.nil?
      self.new({
          :name => g.at_xpath('//name').children.text,
          :description => desc,
          :id => g.attr('principal-id')
        })
    end
  end
end
