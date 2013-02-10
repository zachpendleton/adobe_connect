require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class ConfigTest < MiniTest::Unit::TestCase
  def setup
    @config = AdobeConnect::Config
  end

  def test_bracket_notation_stores_settings
    @config[:test] = true
    assert @config.instance_variable_get(:@settings)[:test]
  end

  def test_bracket_notation_returns_settings
    @config[:test] = '123'
    assert_equal '123', @config[:test]
  end

  def test_declare_stores_a_username
    @config.declare { username 'test@example.com' }
    assert_equal 'test@example.com', @config[:username]
  end

  def test_declare_stores_a_password
    @config.declare { password 'password' }
    assert_equal 'password', @config[:password]
  end

  def test_declare_stores_a_domain
    @config.declare { domain 'http://example.com' }
    assert_equal 'http://example.com', @config[:domain]
  end

  def test_settings_returns_a_hash
    assert_instance_of Hash, @config.settings
  end
end
