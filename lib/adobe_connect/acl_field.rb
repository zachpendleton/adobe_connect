module AdobeConnect

  # Public: Represents a Custom Field object inside of Connect.
  class AclField < Base
    attr_accessor :name, :obj_type, :id, :service

    #
    # id      - The Field-ID of the custom field object.
    # name    - The name of the Field.
    # obj_type- The type of Connect Object this applies to. Allowed values
    #           are: principal, meeting, sco, event, read-only
    #
    def attrs
      atrs = {
        :object_type => "object-type-#{obj_type}", :permission_id => 'manage',
        :name => name, :field_type => 'text', :is_required => false,
        :is_primary => true
      }

      if !id.nil?
        atrs.merge!(:field_id => id)
      end

      atrs
    end

    def self.config
      super.merge({ :ac_obj_type => 'field', :ac_method_prefix => 'custom_field' })
    end

    # Public: Find a folder on the current Connect instance.
    #
    # name, obj_type, service - see #attrs for description
    #
    # Returns a new AdobeConnect::AclField object.
    def self.find_or_create(name, obj_type, service = AdobeConnect::Service.new)
      response = service.custom_fields(:filter_name => name)
      c_flds = response.at_xpath('//custom-fields').children

      if c_flds.count.zero?
        #Create
        fld = self.new({ :name => name, :obj_type => obj_type }, service)
        fld.save
      else
        fld = load_from_xml(c_flds[0])
      end

      fld
    end

    private
    def self.load_from_xml(ac_field, service)
      self.new({
          :id => ac_field.attr('field-id'),
          :name => ac_field.at_xpath('//name').text,
          :obj_type => ac_field.attr('obj_type')
        }, service)
    end
  end
end
