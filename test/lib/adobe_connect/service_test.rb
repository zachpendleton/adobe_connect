require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectServiceTest < AdobeConnectTestCase

  LOGIN_SUCCESS = File.read(File.expand_path('../../fixtures/generic_success.xml', File.dirname(__FILE__)))
  LOGIN_FAIL    = File.read(File.expand_path('../../fixtures/log_in_fail.xml', File.dirname(__FILE__)))

  def setup
    @service = AdobeConnect::Service.new(:username => 'name', :password => 'password',
      :domain => 'http://example.com')
  end

  def test_initialize_takes_a_config_hash
    assert_equal @service.username, 'name'
    assert_equal @service.domain,   URI.parse('http://example.com')
  end

  def test_password_is_not_be_public
    assert_raises(NoMethodError) { @service.password }
  end

  def test_authenticated_defaults_to_false
    assert_equal @service.authenticated?, false
  end

  def test_log_in_authenticates
    response = mock_response(LOGIN_SUCCESS)
    response.expects(:fetch).with('set-cookie').returns('BREEZESESSION=12345')
    @service.client.stubs(:get).returns(response)

    @service.log_in
    assert @service.authenticated?
  end

  def test_log_in_creates_a_session
    response = mock_response(LOGIN_SUCCESS)
    response.expects(:fetch).with('set-cookie').returns('BREEZESESSION=12345;HttpOnly;path=/')
    @service.client.stubs(:get).
      with("/api/xml?action=login&login=name&password=password").
      returns(response)

    @service.log_in
    assert_equal @service.session, '12345'
  end

  def test_log_in_returns_false_on_failure
    response = mock_response(LOGIN_FAIL)
    @service.client.stubs(:get).returns(response)

    refute @service.log_in
  end

  def test_log_in_raises_exception_on_server_unavailable
    response = Net::HTTPServiceUnavailable.new "1.1", 503, "Error"

    @service.stubs(:log_in).returns(true)
    @service.client.stubs(:get).returns(response)
    assert_raises(AdobeConnect::ServerUnavailableError) do
    @service.principal_id!
    end
  end

  def test_unknown_methods_are_proxied_to_the_connect_service
    @service.expects(:request).with('method-name', :a => 1)
    @service.method_name(:a => 1)
  end
end
