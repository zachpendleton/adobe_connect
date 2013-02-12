require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectUserTest < MiniTest::Unit::TestCase

  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  SAVE_SUCCESS = File.read('test/fixtures/user_save_success.xml')
  SAVE_ERROR   = File.read('test/fixtures/user_save_error.xml')
  FIND_SUCCESS = File.read('test/fixtures/user_find_success.xml')
  FIND_ERROR   = File.read('test/fixtures/user_find_error.xml')

  def setup
    @app_user  = stub(:first_name => 'Don', :last_name => 'Draper',
      :email => 'test@example.com', :uuid => '12345')
    @connect_user = AdobeConnect::User.new(@app_user)
  end

  def test_initialize_should_take_a_user
    assert_equal @connect_user.app_user, @app_user
  end

  def test_username_should_be_app_user_email
    assert_equal @connect_user.username, @app_user.email
  end

  def test_password_should_create_a_unique_password
    assert_equal @connect_user.password, @connect_user.password
  end

  def test_password_should_be_ten_characters_long
    assert_equal @connect_user.password.length, 10
  end

  def test_save_persists_user_to_connect_server
    response = mock(:status => 200)
    response.expects(:body).returns(SAVE_SUCCESS)
    ac_response = AdobeConnect::Response.new(response)

    @connect_user.service.expects(:principal_update).
      with(:first_name => @app_user.first_name,
        :last_name => @app_user.last_name, :login => @connect_user.username,
        :password => @connect_user.password, :type => 'user', :has_children => 0,
        :email => @app_user.email).
      returns(ac_response)

    assert @connect_user.save
  end

  def test_save_returns_false_on_failure
    response = mock(:status => 200)
    response.expects(:body).returns(SAVE_ERROR)

    @connect_user.service.
      expects(:principal_update).
      returns(AdobeConnect::Response.new(response))
    refute @connect_user.save
  end

  def test_save_stores_errors_on_failure
    response = mock(:status => 200)
    response.expects(:body).returns(SAVE_ERROR)

    @connect_user.service.
      expects(:principal_update).
      returns(AdobeConnect::Response.new(response))
    @connect_user.save
    assert_equal 3, @connect_user.errors.length
  end

  def test_create_should_return_a_new_user
    AdobeConnect::User.any_instance.expects(:save).returns(true)

    connect_user = AdobeConnect::User.create(@app_user)
    assert_instance_of AdobeConnect::User, connect_user
  end

  def test_find_should_return_an_existing_user
    response = mock(:status => 200)
    response.expects(:body).returns(FIND_SUCCESS)
    AdobeConnect::Service.any_instance.expects(:principal_list).
      with(:filter_login => 'test@example.com').
      returns(AdobeConnect::Response.new(response))

    app_user  = stub(:email => 'test@example.com')
    connect_user = AdobeConnect::User.find(app_user)
    assert_instance_of AdobeConnect::User, connect_user
  end

  def test_find_should_set_user_attributes
    response = mock(:status => 200)
    response.expects(:body).returns(FIND_ERROR)
    AdobeConnect::Service.any_instance.expects(:principal_list).
      returns(AdobeConnect::Response.new(response))

    app_user  = stub(:email => 'notfound@example.com')
    connect_user = AdobeConnect::User.find(app_user)
    assert_nil connect_user
  end
end
