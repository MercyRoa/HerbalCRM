
# Testing code, should be removed
def force_utf(s)
  Iconv.conv('UTF-8//IGNORE', 'UTF-8', s + ' ')[0..-2]
end

class Account < ActiveRecord::Base
  def fetch_emails
    Gmail.new(self.email, self.password) do |gmail|
      gmail.inbox.emails(:unread).each do |email|
        message              = {}
        message[:account_id] = self.id
        message[:message_id] = email.message_id.to_s.tr('<>', '').tr('/', '-')
        message[:subject]    = force_utf(email.subject.to_s)
        message[:from]       = Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }
        message[:to]         = Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }
        message[:date]       = (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil)
        message[:body]       = force_utf( (email.body.parts.first.body.to_s rescue email.body.to_s) )
        message[:body_raw]   = email.body.to_s

        # @ToDo Check if there is already a lead with this email address
        # If email exist, add the message to that lead
        # message[:lead_id] = Lead.id
        # Otherwise create a new lead

        Message.new message
        Message.save

      end
    end
  end
end

