require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectMeetingTest < MiniTest::Unit::TestCase

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

  private
  def obj_attrs
    { description: 'This is an important meeting',
      name: 'Important Meeting', folder_id: '12345' }
  end

  def obj_attrs_posted
    { date_end: nil, date_begin: nil, description: 'This is an important meeting',
      name: 'Important Meeting', url_path: nil, type: 'meeting', folder_id: '12345' }
  end
end
