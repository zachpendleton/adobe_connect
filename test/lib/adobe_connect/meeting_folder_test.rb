require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectMeetingFolderTest < MiniTest::Unit::TestCase

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  FOLDER_SUCCESS  = File.read(File.expand_path('../../fixtures/folder_success.xml', File.dirname(__FILE__)))
  FOLDER_CONTENTS = File.read(File.expand_path('../../fixtures/folder_contents.xml', File.dirname(__FILE__)))

  def setup
    @folder = AdobeConnect::MeetingFolder.new('1', 'test folder', '/test-meeting/')
  end

  def test_initialize_takes_a_name
    assert_equal @folder.name, 'test folder'
  end

  def test_initialize_takes_an_id
    assert_equal @folder.id, '1'
  end

  def test_initialize_takes_a_url
    assert_equal @folder.url, '/test-meeting/'
  end

  def test_initialize_defaults_to_a_new_service
    assert_instance_of AdobeConnect::Service, @folder.service
  end

  def test_find_returns_a_new_folder
    response = mock(:code => '200')
    response.expects(:body).returns(FOLDER_SUCCESS)
    ac_response = AdobeConnect::Response.new(response)

    AdobeConnect::Service.any_instance.
      expects(:request).
      with('sco-search-by-field', :query => 'my_meetings',
        :filter_type => 'folder', :field => 'name').
      returns(ac_response)

    folder = AdobeConnect::MeetingFolder.find('my_meetings')

    assert_instance_of        AdobeConnect::MeetingFolder, folder
    assert_equal folder.name, 'my_meetings'
    assert_equal folder.id,   '25915'
    assert_equal folder.url,  '/meeting-path/'
  end

  def test_contents_returns_folder_contents
    response = mock(:code => '200')
    response.expects(:body).returns(FOLDER_CONTENTS)
    ac_response = AdobeConnect::Response.new(response)
    @folder.service.expects(:sco_contents).returns(ac_response)

    assert_equal @folder.contents.xpath('//sco').length, 10
  end
end
