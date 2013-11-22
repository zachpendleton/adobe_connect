require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectAclFieldTest < AdobeConnectTestCase

  include AdobeConnectBaseTests

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_attrs_does_not_contain_field_id_when_unpersisted
    attrs = @connect_acl_field.attrs

    assert !attrs.has_key?(:field_id)
  end

  def test_attrs_contain_field_id_when_persisted
    @connect_acl_field.instance_variable_set(:@id, '54321')

    attrs = @connect_acl_field.attrs

    assert attrs.has_key?(:field_id)
    assert_equal '54321', attrs[:field_id]
  end

  private
  def obj_attrs
    { name: 'Phone', obj_type: 'principal' }
  end

  def obj_attrs_posted
    { :object_type => 'object-type-principal', :permission_id => 'manage',
      :name => 'Phone', :field_type => 'text', :is_required => false,
      :is_primary => true
    }
  end
end
