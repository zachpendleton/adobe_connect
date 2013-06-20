module AdobeConnect

  # Provides base interaction with Adobe Connect for a variety of AC Objects
  class Base
    # Public: SCO-ID from the Adobe Connect instance.
    attr_reader :id

    attr_reader :service, :errors

    def initialize(obj_options, service = Service.new)
      obj_options.each { |key, value| send(:"#{key}=", value) }
      @service  = service
      @errors   = []
    end

    def attrs
      {}
    end

    # Public: Save this user to the Adobe Connect instance.
    #
    # Returns a boolean.
    def save
      acot = self.class.config[:ac_obj_type]
      response = service.send(:"#{acot}_update", self.attrs)

      if response.at_xpath('//status').attr('code') == 'ok'
        self.id = response.at_xpath("//#{acot}").attr("#{acot}-id")
        true
      else
        save_errors(response)
        false
      end
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
  end
end
