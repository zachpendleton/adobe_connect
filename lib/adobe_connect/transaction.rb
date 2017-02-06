module AdobeConnect

  class Transaction < Base
    attr_accessor :id, :name, :status, :date_created, :date_closed, :login, :user_name, :sco_id, :principal_id, :url

    def attrs
      atrs = {
        name: name,
        url: url,
        login: login,
        user_name: user_name,
        status: status,
        date_created: date_created,
        date_closed: date_closed
      }
    end

    def self.find_by_meeting(sco_id, params = {}, service = AdobeConnect::Service.new)
      response = service.report_bulk_consolidated_transactions( params.merge(filter_sco_id: sco_id, type: 'meeting') )
      bulk_transactions = response.at_xpath('//report-bulk-consolidated-transactions')
      transactions = bulk_transactions.children.map{|t| load_from_xml(t, service) }
    end

    private
    def self.load_from_xml(bulk_transaction, service)
      transaction = self.new({}, service)

      transaction.attrs.each do |atr,v|
        chld = bulk_transaction.children.select{|t| t.name == atr.to_s.dasherize}[0]
        unless chld.nil?
          transaction.send(:"#{atr}=", chld.text)
        end
      end

      transaction.sco_id = bulk_transaction.attr('sco-id')
      transaction.principal_id = bulk_transaction.attr('principal-id')
      transaction.instance_variable_set(:@id, bulk_transaction.attr('transaction-id'))

      transaction
    end

  end
end
