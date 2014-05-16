require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectMeetingTest < AdobeConnectTestCase

  include AdobeConnectBaseTests

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_attrs_contain_type_and_folder_id_when_unpersisted
    attrs = @connect_meeting.attrs

    assert attrs.has_key?(:type)
    assert attrs.has_key?(:folder_id)
    assert !attrs.has_key?(:sco_id)
  end

  def test_attrs_contain_sco_id_when_persisted
    @connect_meeting.instance_variable_set(:@id, '54321')

    attrs = @connect_meeting.attrs

    assert !attrs.has_key?(:folder_id)
    assert attrs.has_key?(:sco_id)
    assert_equal '54321', attrs[:sco_id]
  end

  def test_find_by_id_should_return_existing_meeting
    response = mock_ac_response(responses[:find_by_id_success])
    AdobeConnect::Service.any_instance.expects(:sco_info).
      with(:sco_id => '98765').
      returns(response)

    connect_meeting = AdobeConnect::Meeting.find_by_id('98765')
    assert_instance_of AdobeConnect::Meeting, connect_meeting
  end

  def test_find_by_id_should_return_nil_if_not_found
    response = mock_ac_response(responses[:find_by_id_error])
    AdobeConnect::Service.any_instance.expects(:sco_info).
      with(:sco_id => '98765').
      returns(response)

    connect_meeting = AdobeConnect::Meeting.find_by_id('98765')
    assert_nil connect_meeting
  end

  def test_add_participant_to_meeting
    response = mock_ac_response(responses[:generic_success])

    AdobeConnect::Service.any_instance.
      expects(:permissions_update).
      with(:acl_id => @connect_meeting.id,
        :principal_id => 123,
        :permission_id =>'view').
      returns(response)

      assert @connect_meeting.add_participant(123)
  end

  def test_add_presenter_to_meeting
    response = mock_ac_response(responses[:generic_success])

    AdobeConnect::Service.any_instance.
      expects(:permissions_update).
      with(:acl_id => @connect_meeting.id,
        :principal_id => 123,
        :permission_id =>'mini-host').
      returns(response)

      assert @connect_meeting.add_presenter(123)
  end

  def test_add_host_to_meeting
    response = mock_ac_response(responses[:generic_success])

    AdobeConnect::Service.any_instance.
      expects(:permissions_update).
      with(:acl_id => @connect_meeting.id,
        :principal_id => 123,
        :permission_id =>'host').
      returns(response)

      assert @connect_meeting.add_host(123)
  end

  def test_remove_user_from_meeting
    response = mock_ac_response(responses[:generic_success])

    AdobeConnect::Service.any_instance.
      expects(:permissions_update).
      with(:acl_id => @connect_meeting.id,
        :principal_id => 123,
        :permission_id =>'remove').
      returns(response)

      assert @connect_meeting.remove_user(123)
  end

  private
  def obj_attrs
    { description: 'This is an important meeting',
      name: 'Important Meeting', folder_id: '12345' }
  end

  def obj_attrs_posted
    { date_end: nil, date_begin: nil, description: 'This is an important meeting',
      name: 'Important Meeting', url_path: nil, type: 'meeting', folder_id: '12345' }
  end

  def responses
    super.merge(load_responses([:find_by_id_success, :find_by_id_error]))
  end
end
