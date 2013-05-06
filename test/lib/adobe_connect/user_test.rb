require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectUserTest < MiniTest::Unit::TestCase

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  SAVE_SUCCESS = File.read(File.expand_path('../../fixtures/user_save_success.xml', File.dirname(__FILE__)))
  SAVE_ERROR   = File.read(File.expand_path('../../fixtures/user_save_error.xml', File.dirname(__FILE__)))
  FIND_SUCCESS = File.read(File.expand_path('../../fixtures/user_find_success.xml', File.dirname(__FILE__)))
  FIND_ERROR   = File.read(File.expand_path('../../fixtures/user_find_error.xml', File.dirname(__FILE__)))

  def setup
    @user_options = { first_name: 'Don', last_name: 'Draper',
      email: 'test@example.com', uuid: '12345' }
    @connect_user = AdobeConnect::User.new(@user_options)
  end

  def test_initialize_takes_a_user
    @user_options.each do |key, value|
      assert_equal @connect_user.send(key), value
    end
  end

  def test_username_falls_back_to_email
    assert_equal @connect_user.email, @connect_user.username
  end

  def test_username_is_settable
    @connect_user.username = 'my_username'
    assert_equal 'my_username', @connect_user.username
  end

  def test_password_creates_a_unique_password
    assert_equal @connect_user.password, @connect_user.password
  end

  def test_password_is_ten_characters_long
    assert_equal @connect_user.password.length, 10
  end

  def test_save_persists_user_to_connect_server
    response = mock(:code => '200')
    response.expects(:body).returns(SAVE_SUCCESS)
    ac_response = AdobeConnect::Response.new(response)

    @connect_user.service.expects(:principal_update).
      with(:first_name => @user_options[:first_name],
        :last_name => @user_options[:last_name], :login => @connect_user.username,
        :password => @connect_user.password, :type => 'user', :has_children => 0,
        :email => @connect_user.email).
      returns(ac_response)

    assert @connect_user.save
  end

  def test_save_stores_the_principal_id_on_the_user
    response = mock(:code => '200')
    response.expects(:body).returns(SAVE_SUCCESS)
    ac_response = AdobeConnect::Response.new(response)

    @connect_user.service.expects(:principal_update).
      with(:first_name => @user_options[:first_name],
        :last_name => @user_options[:last_name], :login => @connect_user.username,
        :password => @connect_user.password, :type => 'user', :has_children => 0,
        :email => @user_options[:email]).
      returns(ac_response)

    @connect_user.save

    assert_equal "26243", @connect_user.id
  end

  def test_save_returns_false_on_failure
    response = mock(:code => '200')
    response.expects(:body).returns(SAVE_ERROR)

    @connect_user.service.
      expects(:principal_update).
      returns(AdobeConnect::Response.new(response))
    refute @connect_user.save
  end

  def test_save_stores_errors_on_failure
    response = mock(:code => '200')
    response.expects(:body).returns(SAVE_ERROR)

    @connect_user.service.
      expects(:principal_update).
      returns(AdobeConnect::Response.new(response))
    @connect_user.save
    assert_equal 3, @connect_user.errors.length
  end

  def test_create_should_return_a_new_user
    AdobeConnect::User.any_instance.expects(:save).returns(true)

    connect_user = AdobeConnect::User.create(@user_options)
    assert_instance_of AdobeConnect::User, connect_user
  end

  def test_find_should_return_an_existing_user
    response = mock(:code => '200')
    response.expects(:body).returns(FIND_SUCCESS)
    AdobeConnect::Service.any_instance.expects(:principal_list).
      with(:filter_login => 'test@example.com').
      returns(AdobeConnect::Response.new(response))

    connect_user = AdobeConnect::User.find(email: 'test@example.com')
    assert_instance_of AdobeConnect::User, connect_user
  end

  def test_find_should_set_user_attributes
    response = mock(:code => '200')
    response.expects(:body).returns(FIND_ERROR)
    AdobeConnect::Service.any_instance.expects(:principal_list).
      returns(AdobeConnect::Response.new(response))

    connect_user = AdobeConnect::User.find(email: 'notfound@example.com')
    assert_nil connect_user
  end
end
