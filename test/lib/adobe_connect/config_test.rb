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

  def test_declare_stores_new_settings
    @config.declare(a: 1)
    assert_equal 1, @config[:a]
  end

  def test_declare_overwrites_existing_settings
    @config[:a] = 1
    @config.declare(a: 2)
    assert_equal 2, @config[:a]
  end

  def test_settings_returns_a_hash
    assert_instance_of Hash, @config.settings
  end

end
