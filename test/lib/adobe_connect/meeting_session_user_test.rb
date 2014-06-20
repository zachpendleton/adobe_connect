require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectMeetingSessionUserTest < AdobeConnectTestCase
  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_find_by_session_should_return_session_users
    response = mock_ac_response(response_file_xml)
    AdobeConnect::Service.any_instance.expects(:report_meeting_session_users).
      with(sco_id: '98765', asset_id: '1234').
      returns(response)

    connect_session_users = AdobeConnect::MeetingSessionUser.find_by_session('98765', '1234')
    assert_instance_of AdobeConnect::MeetingSessionUser, connect_session_users.first
  end

  private

  def response_file_xml
    File.read(
      File.expand_path("../../fixtures/meeting_session_user_find_by_session_success.xml",
        File.dirname(__FILE__))
    ).gsub(/\n\s+/, '')
  end
end
