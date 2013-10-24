require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectTelephonyProfileTest < AdobeConnectTestCase

  include AdobeConnectBaseTests

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_find_by_name
    list_response = mock_ac_response(responses[:list_success])
    info_response = mock_ac_response(responses[:info_success])

    service = AdobeConnect::Service.new
    service.
      expects(:telephony_profile_list).
      returns(list_response)
    service.
      expects(:telephony_profile_info).
      returns(info_response)

    sc = @obj_class.find_by_name('SoundConnect', nil, service)
    assert_equal 26243, sc.id.to_i
  end

  private
  def obj_attrs
    { :status=>"enabled", :provider_id=>"987654321", :name=>"SoundConnect"}
  end

  def obj_attrs_posted
    {:profile_status=>"enabled", :provider_id=>"987654321", :profile_name=>"SoundConnect"}
  end

  def responses
    super.merge(load_responses([:list_success, :info_success]))
  end
end
