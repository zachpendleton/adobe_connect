require File.expand_path('../../test_helper.rb', File.dirname(__FILE__))

class AdobeConnectTransactionTest < AdobeConnectTestCase
  AdobeConnect::Config.declare do
    username 'test@example.com'
    password 'pwd'
    domain   'http://example.com'
  end

  def test_find_by_meeting_should_return_transactions
    response = mock_ac_response(response_file_xml)
    AdobeConnect::Service.any_instance.expects(:report_bulk_consolidated_transactions).
      with(filter_sco_id: '98765', type: 'meeting').
      returns(response)

    connect_transactions = AdobeConnect::Transaction.find_by_meeting('98765')
    assert_instance_of AdobeConnect::Transaction, connect_transactions.first
  end

  private

  def response_file_xml
    File.read(
      File.expand_path("../../fixtures/transaction_find_by_meeting_success.xml",
        File.dirname(__FILE__))
    ).gsub(/\n\s+/, '')
  end
end
