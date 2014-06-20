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

  def test_add_member_to_group
    response = mock_ac_response(responses[:generic_success])

    @connect_group.service.
      expects(:group_membership_update).
      returns(response)

    user_stub = mock
    user_stub.expects(:id).returns(12345)

    assert @connect_group.add_member(user_stub)
  end

  def test_user_is_member_of_group
    response = mock_ac_response(responses[:is_member])

    @connect_group.id = 12345

    @connect_group.service.
      expects(:principal_list).
      returns(response)

    assert @connect_group.is_member?('testuser@example.com')
  end

  def test_user_is_not_member_of_group
    response = mock_ac_response(responses[:is_not_member])

    @connect_group.id = 12345

    @connect_group.service.
      expects(:principal_list).
      returns(response)

    refute @connect_group.is_member?('testuser@example.com')
  end

  def test_find_by_type_should_return_existing_group
    response = mock_ac_response(responses[:find_by_type_success])
    AdobeConnect::Service.any_instance.expects(:principal_list).
      with(:filter_type => 'live-admins').
      returns(response)

    connect_group = AdobeConnect::Group.find_by_type('live-admins')
    assert_instance_of AdobeConnect::Group, connect_group
  end

  private
  def obj_attrs
    { name: 'Test group', description: 'This is for testing' }
  end

  def obj_attrs_posted
    { name: 'Test group', description: 'This is for testing', :type => 'group', :has_children => 1 }
  end

  def responses
    super.merge(load_responses([:is_member, :is_not_member, :find_by_type_success]))
  end
end
