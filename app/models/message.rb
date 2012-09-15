# encode: UTF-8

class Message < ActiveRecord::Base
  belongs_to :lead
  belongs_to :account
  validates_uniqueness_of :message_id
  before_save lambda { self.from_account? = true if self.from_account? }

  def from_account?
    self.from == self.account.email
  end

  # Metodos estaticos
  class << self
    def import_emails_from_gmail(emails, account, label)
      done = 0
      puts "Importing #{emails.count} messages, press Ctrl-C to abort...", '-'*80
      emails.each do |email|
        puts "Processing message... #{email.subject}"
        m = convert_from_gmail email
        m.account = account
        m.lead_id    = Lead.get_or_create( email.from_addrs.first, account, email.from.first.name).id

        begin
          email.label! label
          m.save
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{m.subject} <#{email.from_addrs.join(', ')}> <#{email.to_addrs.join(', ')}>"
          done += 1
        rescue Exception => e
          # Display failure message
          puts "\e[31m[!]\e[0m  #{m.subject} <#{email.from_addrs.join(', ')}> <#{email.to_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          email.unread!
          email.remove_label! label
        end
      end
    end

    def convert_from_gmail email
      self.new({
        message_id: email.message_id.to_s, #.tr('<>', '').tr('/', '-')
        subject:    email.subject,
        from_raw:       Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
        to_raw:         Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
        from:       email.from_addrs.first,
        to:         email.to_addrs.first,
        date:       (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil),
        #body:       (email.body.parts.first.body.to_s rescue email.body.to_s).gsub( /^From: .*@.*/m, '').strip.force_encoding('UTF-8'),
        body:       ((email.multipart?)? email.text_part : email.body).decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip,
        body_raw:   (email.multipart?)? email.html_part.body.decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip : ''
      })
    end

    def check_if_is_mailer_daemon

    end
  end
end
