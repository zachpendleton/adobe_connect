module AdobeConnect

  class MeetingSession < Base
    attr_accessor :asset_id, :date_created, :date_end, :num_participants, :sco_id

    def attrs
      atrs = {
        date_created: date_created,
        date_end: date_end
      }
    end

    def self.find_by_meeting(sco_id, params = {}, service = AdobeConnect::Service.new)
      response = service.report_meeting_sessions(params.merge(sco_id: sco_id))
      meeting_session_rows = response.at_xpath('//report-meeting-sessions')

      if meeting_session_rows.nil?
        []
      else
        meeting_sessions = meeting_session_rows.children.map{|t| load_from_xml(t, service) }
      end
    end

    private
    def self.load_from_xml(meeting_session_row, service)
      meeting_session = self.new({}, service)

      meeting_session.attrs.each do |atr,v|
        chld = meeting_session_row.children.select{|t| t.name == atr.to_s.dasherize}[0]
        unless chld.nil?
          meeting_session.send(:"#{atr}=", chld.text)
        end
      end

      meeting_session.sco_id = meeting_session_row.attr('sco-id')
      meeting_session.num_participants = meeting_session_row.attr('num-participants')
      meeting_session.instance_variable_set(:@id, meeting_session_row.attr('asset-id'))

      meeting_session
    end
  end
end
