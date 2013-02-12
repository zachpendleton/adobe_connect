require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectResponseTest < MiniTest::Unit::TestCase

  TEST_HEADERS = { 'Accept' => 'application/json' }
  TEST_BODY    = <<-END
    <?xml version="1.0" encoding="utf-8"?>
    <response>
      <name>Test</name>
    </response>
  END

  def setup
    response  = stub(:code => "200", :headers => TEST_HEADERS, :body => TEST_BODY)
    @response = AdobeConnect::Response.new(response)
  end

  def test_initialize_takes_a_net_http_response
    assert @response.instance_variable_get(:@response)
  end

  def test_initialize_creates_a_nokogiri_wrapped_body
    assert_instance_of Nokogiri::XML::Document, @response.body
  end

  def test_response_has_a_status
    assert_equal 200, @response.status
  end

  def test_fetch_delegates_to_response
    @response.instance_variable_get(:@response).expects(:fetch).with('Accept')
    @response.fetch('Accept')
  end

  def test_xpath_delegates_to_body
    @response.body.expects(:xpath).with('//name')
    @response.xpath('//name')
  end

  def test_at_xpath_delegates_to_body
    @response.body.expects(:at_xpath).with('//name')
    @response.at_xpath('//name')
  end
end
