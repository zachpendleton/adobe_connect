require 'minitest/autorun'
require 'mocha/setup'
require 'pry'

require File.expand_path('../lib/adobe_connect.rb', File.dirname(__FILE__))

# Shared base tests for some objs
require File.expand_path('lib/adobe_connect/adobe_connect_base_tests.rb', File.dirname(__FILE__))

class AdobeConnectTestCase < Minitest::Test
  def mock_ac_response(*args)
    resp = mock_response(*args)
    AdobeConnect::Response.new(resp)
  end

  def mock_response(body, code = '200')
    response = mock(:code => code)
    response.expects(:body).returns(body)
    response
  end
end
