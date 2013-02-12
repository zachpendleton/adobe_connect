require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectParamFormatterTest < MiniTest::Unit::TestCase
  def setup
    params        = { :a => 1, :b => 'param value', 'dashed_value' => 3 }
    @formatter    = AdobeConnect::ParamFormatter.new(params)
    @query_string = @formatter.format
  end

  def test_format_formats_params_hash_to_a_string
    assert_instance_of String, @query_string
  end

  def test_format_includes_basic_params
    assert_match Regexp.new('a=1'), @query_string
  end

  def test_format_sorts_params_alphabetically
    assert_match Regexp.new('a=.+b=.+dashed\-value'), @query_string
  end

  def test_format_escapes_params
    assert_match Regexp.new('b=param%20value'), @query_string
  end

  def test_format_dasherizes_underscored_keys
    assert_match Regexp.new('dashed-value'), @query_string
  end

  def test_format_includes_a_leading_ampersand
    assert_match Regexp.new('^&'), @query_string
  end

  def test_an_empty_hash_should_return_an_empty_string
    assert_equal AdobeConnect::ParamFormatter.new({}).format, ''
  end
end
