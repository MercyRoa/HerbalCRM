
class Account < ActiveRecord::Base
  def gmail
    Gmail.new(self.email, self.password)
  end

  def fetch_emails
    puts "Conectandose"
    Gmail.new(self.email, self.password) do |gmail|
      gmail.inbox.emails(:unread).each do |email|
        puts "procesando mensaje"
        message              = {}
        message[:account_id] = self.id
        message[:message_id] = email.message_id.to_s.tr('<>', '').tr('/', '-')
        message[:subject]    = email.subject.to_s
        message[:from]       = Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }
        message[:to]         = Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }
        message[:date]       = (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil)
        message[:body]       = (email.body.parts.first.body.to_s rescue email.body.to_s)
        message[:body_raw]   = email.body.to_s

        # @ToDo Check if there is already a lead with this email address
        # If email exist, add the message to that lead
        # message[:lead_id] = Lead.id
        # Otherwise create a new lead
        puts message.to_yaml
        m = Message.new message
        m.save

      end
    end
  end
end

