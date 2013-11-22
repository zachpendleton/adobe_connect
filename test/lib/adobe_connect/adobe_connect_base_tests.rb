module AdobeConnectBaseTests

  def setup
    super
    @ac_class = self.class.to_s.gsub(/^AdobeConnect/, '').gsub(/Test$/,'')
    @obj_class = "AdobeConnect::#{@ac_class}".constantize
    @connect_obj = @obj_class.new(obj_attrs)
    self.instance_variable_set(:"@connect_#{@ac_class.underscore.downcase}", @connect_obj)
    @method_prefix = @obj_class.config[:ac_method_prefix] || @obj_class.config[:ac_obj_type]
  end

  def test_initialize_takes_a_hash_with_appropriate_keys
    obj_attrs.each do |key, value|
      assert_equal @connect_obj.send(key), value
    end
  end

  def test_save_persists_obj_to_connect_server
    ac_response = mock_ac_response(responses[:save_success])

    @connect_obj.service.expects(:"#{@method_prefix}_update").
      with(obj_attrs_posted).
      returns(ac_response)

    assert @connect_obj.save
  end

  def test_save_stores_the_obj_id_on_the_obj
    ac_response = mock_ac_response(responses[:save_success])

    @connect_obj.service.expects(:"#{@method_prefix}_update").
      with(obj_attrs_posted).
      returns(ac_response)

    @connect_obj.save

    assert_equal "26243", @connect_obj.id
  end

  def test_save_returns_false_on_failure
    response = mock_ac_response(responses[:save_error])

    @connect_obj.service.
      expects(:"#{@method_prefix}_update").
      returns(response)
    refute @connect_obj.save
  end

  def test_save_stores_errors_on_failure
    response = mock_ac_response(responses[:save_error])

    @connect_obj.service.
      expects(:"#{@method_prefix}_update").
      returns(response)
    @connect_obj.save
    refute_equal 0, @connect_obj.errors.length
  end

  def test_create_should_return_a_new_obj
    @obj_class.any_instance.expects(:save).returns(true)

    connect_obj = @obj_class.create(obj_attrs)
    assert_instance_of @obj_class, connect_obj
  end

  def test_should_update_obj
    response = mock_ac_response(responses[:update_success])

    @connect_obj.instance_variable_set(:@id, 26243)

    @connect_obj.service.
      expects(:"#{@method_prefix}_update").
      returns(response)

    assert @connect_obj.save
  end

  def test_should_delete_obj
    response = mock_ac_response(responses[:generic_success])

    @connect_obj.service.
      expects(:"#{@connect_obj.send(:delete_method_prefix)}_delete").
      returns(response)

    assert @connect_obj.delete
  end

  private
  def load_responses(responses)
    responses.reduce({}) {|rsps, rsp|
      rsps.merge(rsp => response_file(rsp.to_s))
    }
  end

  def response_file(resp_name, prefix = nil)
    prefix ||= @ac_class.underscore.downcase
    File.read(
      File.expand_path("../../fixtures/#{prefix}_#{resp_name}.xml",
        File.dirname(__FILE__))
    ).gsub(/\n\s+/, '') #Strip indentation and new lines, they cause issues
  end

  def responses
    @rsps ||= load_responses([:save_success, :save_error, :update_success]).
                merge(:generic_success => response_file('success', 'generic'))
  end

end
