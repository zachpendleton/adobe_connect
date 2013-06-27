require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectUserTest < AdobeConnectTestCase

  include AdobeConnectBaseTests

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_username_falls_back_to_email
    assert_equal @connect_user.email, @connect_user.username
  end

  def test_username_is_settable
    @connect_user.username = 'my_username'
    assert_equal 'my_username', @connect_user.username
  end

  def test_send_email_is_settable
    @connect_user.send_email = 'me@example.com'
    assert_equal 'me@example.com', @connect_user.send_email
  end

  def test_password_creates_a_unique_password
    assert_equal @connect_user.password, @connect_user.password
  end

  def test_password_is_ten_characters_long
    assert_equal @connect_user.password.length, 10
  end

  def test_find_should_return_an_existing_user
    response = mock_ac_response(responses[:find_success])
    AdobeConnect::Service.any_instance.expects(:principal_list).
      with(:filter_login => 'test@example.com').
      returns(response)

    connect_user = AdobeConnect::User.find(email: 'test@example.com')
    assert_instance_of AdobeConnect::User, connect_user
  end

  def test_find_should_set_user_attributes
    response = mock_ac_response(responses[:find_error])
    AdobeConnect::Service.any_instance.expects(:principal_list).
      returns(response)

    connect_user = AdobeConnect::User.find(email: 'notfound@example.com')
    assert_nil connect_user
  end

  private
  def obj_attrs
    { first_name: 'Don', last_name: 'Draper',
      email: 'test@example.com', uuid: '12345' }
  end

  def obj_attrs_posted
    { :first_name => obj_attrs[:first_name],
      :last_name => obj_attrs[:last_name], :login => @connect_obj.username,
      :password => @connect_obj.password, :type => 'user', :has_children => 0,
      :email => obj_attrs[:email], :send_email => @connect_obj.send_email }
  end

  def responses
    super.merge({
      :find_success => File.read(File.expand_path('../../fixtures/user_find_success.xml', File.dirname(__FILE__))),
      :find_error   => File.read(File.expand_path('../../fixtures/user_find_error.xml', File.dirname(__FILE__)))
    })
  end
end
