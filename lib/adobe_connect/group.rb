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
    def self.load_from_xml(g)
      self.new({
          :name => g.at_xpath('//name').children.text,
          :description => g.at_xpath('//description').children.text,
          :id => g.attr('principal-id')
        })
    end
  end
end
