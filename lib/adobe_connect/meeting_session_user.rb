module AdobeConnect

  class MeetingSessionUser < Base
    attr_accessor :principal_id, :principal_name, :date_created, :date_end

    def attrs
      atrs = {
        date_created: date_created,
        date_end: date_end,
        principal_name: principal_name
      }
    end

    def self.find_by_session(sco_id, asset_id, params = {}, service = AdobeConnect::Service.new)
      response = service.report_meeting_session_users(params.merge(sco_id: sco_id, asset_id: asset_id))
      meeting_user_rows = response.at_xpath('//report-meeting-session-users')

      if meeting_user_rows.nil?
        []
      else
        meeting_users = meeting_user_rows.children.map{|t| load_from_xml(t, service) }
      end
    end

    private
    def self.load_from_xml(meeting_user_row, service)
      meeting_session_user = self.new({}, service)

      meeting_session_user.attrs.each do |atr,v|
        chld = meeting_user_row.children.select{|t| t.name == atr.to_s.dasherize}[0]
        unless chld.nil?
          meeting_session_user.send(:"#{atr}=", chld.text)
        end
      end

      meeting_session_user.principal_id = meeting_user_row.attr('principal-id')

      meeting_session_user
    end
  end
end
