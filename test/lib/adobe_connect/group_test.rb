require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectGroupTest < AdobeConnectTestCase

  include AdobeConnectBaseTests

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_attrs_does_not_contain_principal_id_when_unpersisted
    attrs = @connect_group.attrs

    assert !attrs.has_key?(:principal_id)
  end

  def test_attrs_contain_principal_id_when_persisted
    @connect_group.instance_variable_set(:@id, '54321')

    attrs = @connect_group.attrs

    assert attrs.has_key?(:principal_id)
    assert_equal '54321', attrs[:principal_id]
  end

  private
  def obj_attrs
    { name: 'Test group', description: 'This is for testing' }
  end

  def obj_attrs_posted
    { name: 'Test group', description: 'This is for testing', :type => 'group', :has_children => 1 }
  end
end
