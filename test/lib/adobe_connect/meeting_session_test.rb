require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectMeetingSessionTest < AdobeConnectTestCase
  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_find_by_meeting_should_return_sessions
    response = mock_ac_response(response_file_xml)
    AdobeConnect::Service.any_instance.expects(:report_meeting_sessions).
      with(sco_id: '98765').
      returns(response)

    connect_sessions = AdobeConnect::MeetingSession.find_by_meeting('98765')
    assert_instance_of AdobeConnect::MeetingSession, connect_sessions.first
  end

  private

  def response_file_xml
    File.read(
      File.expand_path("../../fixtures/meeting_session_find_by_meeting_success.xml",
        File.dirname(__FILE__))
    ).gsub(/\n\s+/, '')
  end
end
