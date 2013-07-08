module AdobeConnect

  # Provides base interaction with Adobe Connect for a variety of AC Objects
  class Base
    # Public: SCO-ID from the Adobe Connect instance.
    attr_reader :id

    attr_reader :service, :errors

    def initialize(obj_options, service = Service.new)
      set_attrs(obj_options)
      @service  = service
      @errors   = []
    end

    def attrs
      {}
    end

    # Public: Save this object to the Adobe Connect instance.
    #
    # Returns a boolean.
    def save
      acot = self.class.config[:ac_obj_type]
      ac_method = self.class.config[:ac_method_prefix] || acot
      response = service.send(:"#{ac_method}_update", self.attrs)

      if response.at_xpath('//status').attr('code') == 'ok'
        # Load the ID if this was a creation
        self.id = response.at_xpath("//#{acot}").attr("#{acot}-id") if self.id.nil?
        true
      else
        save_errors(response)
        false
      end
    end

    # Public: Update attributes of the loaded object and save.
    #
    # atrs - Generic options (see #initialize for required
    #   attributes).
    #
    # Returns a boolean.
    def update_attributes(atrs)
      set_attrs(atrs)
      self.save
    end

    # Public: Create a Connect obj from the given app obj.
    #
    # obj_options - Generic options (see #initialize for required
    #   attributes).
    #
    # Returns an instance of this class, with an attempted save.
    def self.create(obj_options)
      obj = self.new(obj_options)
      obj.save

      obj
    end

    def self.config
      { :ac_obj_type => 'principal' }
    end

    private
    attr_writer :id

    # Internal: Store request errors in @errors.
    #
    # response - An AdobeConnect::Response.
    #
    # Returns nothing.
    def save_errors(response)
      @errors = response.xpath('//invalid').map(&:attributes)
    end

    # Internal: Update attributes from an attribute hash
    #
    # atrs - A hash of keys that match attributes of this object and
    #   corresponding values for those attributes.
    #
    # Returns nothing.
    def set_attrs(atrs)
      atrs.each { |key, value| send(:"#{key}=", value) }
    end
  end
end
