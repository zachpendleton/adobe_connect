module AdobeConnectBaseTests

  def setup
    super
    @ac_class = self.class.to_s.gsub(/^AdobeConnect/, '').gsub(/Test$/,'')
    @obj_class = "AdobeConnect::#{@ac_class}".constantize
    @connect_obj = @obj_class.new(obj_attrs)
    self.instance_variable_set(:"@connect_#{@ac_class.downcase}", @connect_obj)
  end

  def test_initialize_takes_a_hash_with_appropriate_keys
    obj_attrs.each do |key, value|
      assert_equal @connect_obj.send(key), value
    end
  end

  def test_save_persists_obj_to_connect_server
    response = mock(:code => '200')
    response.expects(:body).returns(responses[:save_success])
    ac_response = AdobeConnect::Response.new(response)

    @connect_obj.service.expects(:"#{@obj_class.config[:ac_obj_type]}_update").
      with(obj_attrs_posted).
      returns(ac_response)

    assert @connect_obj.save
  end

  def test_save_stores_the_obj_id_on_the_obj
    response = mock(:code => '200')
    response.expects(:body).returns(responses[:save_success])
    ac_response = AdobeConnect::Response.new(response)

    @connect_obj.service.expects(:"#{@obj_class.config[:ac_obj_type]}_update").
      with(obj_attrs_posted).
      returns(ac_response)

    @connect_obj.save

    assert_equal "26243", @connect_obj.id
  end

  def test_save_returns_false_on_failure
    response = mock(:code => '200')
    response.expects(:body).returns(responses[:save_error])

    @connect_obj.service.
      expects(:"#{@obj_class.config[:ac_obj_type]}_update").
      returns(AdobeConnect::Response.new(response))
    refute @connect_obj.save
  end

  def test_save_stores_errors_on_failure
    response = mock(:code => '200')
    response.expects(:body).returns(responses[:save_error])

    @connect_obj.service.
      expects(:"#{@obj_class.config[:ac_obj_type]}_update").
      returns(AdobeConnect::Response.new(response))
    @connect_obj.save
    refute_equal 0, @connect_obj.errors.length
  end

  def test_create_should_return_a_new_obj
    @obj_class.any_instance.expects(:save).returns(true)

    connect_obj = @obj_class.create(obj_attrs)
    assert_instance_of @obj_class, connect_obj
  end

  def test_should_update_obj
    response = mock(:code => '200')
    response.expects(:body).returns(responses[:update_success])

    @connect_obj.instance_variable_set(:@id, 26243)

    @connect_obj.service.
      expects(:"#{@obj_class.config[:ac_obj_type]}_update").
      returns(AdobeConnect::Response.new(response))

    assert @connect_obj.save
  end

  private
  def responses
    {
      :save_success => File.read(File.expand_path("../../fixtures/#{@ac_class}_save_success.xml", File.dirname(__FILE__))),
      :save_error   => File.read(File.expand_path("../../fixtures/#{@ac_class}_save_error.xml", File.dirname(__FILE__))),
      :update_success => File.read(File.expand_path("../../fixtures/#{@ac_class}_update_success.xml", File.dirname(__FILE__)))
    }
  end

end
