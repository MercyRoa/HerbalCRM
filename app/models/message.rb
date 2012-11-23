# encode: UTF-8

class Message < ActiveRecord::Base
  order :date, 'DESC'

  belongs_to :lead
  belongs_to :account

  validates_uniqueness_of :message_id
  before_save lambda { self.from_account = true if self.from_account? }
  before_save lambda { self.from.downcase! }
  after_save :update_lead_counters
  after_destroy :update_lead_counters

  MAILER_DAEMONS = ['mailer-daemon@googlemail.com', 'postmaster@hotmail.com']

  def to_s
    body.gsub( /^(From:.*@|>) .*/m, '').strip
  end

  def update_lead_counters
    self.lead.messages_sent_count = Message.count( :conditions => ["countable = true AND from_account = true AND lead_id = ?", self.lead.id])
    self.lead.messages_received_count = Message.count( :conditions => ["countable = true AND from_account = false AND lead_id = ?", self.lead.id])
    self.lead.save
  end

  def from_account?
    return self.from_account unless self.id.nil?
    self.from == self.account.email
  end

  def lead_email
    from_account? ? to : from;
  end

  def is_mailer_daemon?
    MAILER_DAEMONS.include? self.from
  end

  # Compare message date to the last received message from lead table
  def is_more_recent?
    self.lead.last_contacted.nil? || self.date > self.lead.last_contacted
  end

  # Class Methods
  class << self
    def extract_email text
      text.match(/[a-zA-Z0-9._-]+@[a-zA-Z0-9\.-]+/).to_s
    end

    # @param [Object] emails
    # @param [Account] account
    # @param [String] label
    def import_emails_from_gmail(emails, account, campaign, label)
      Dir[Rails.root.to_s + '/lib/mail_processor/*.rb'].each {|file| require file }

      done = 0
      puts "Importing #{emails.count} messages, press Ctrl-C to abort...", '-'*80
      emails.each do |email|
        puts "Processing message... #{email.subject}, #{email.from_addrs.first}"
        m = convert_from_gmail email
        m.account = account
        puts "done converting..."

        # ToDo refactor this ugly piece of code!
        if m.is_mailer_daemon?
          m.countable = false
          m.lead = Lead.get_or_create( extract_email(m.body), account, campaign)
          m.lead.increment :bounce
          m.lead.status = 'bounced'
          m.lead.automatic = false

          m.lead.save
        else

          #parse MailProcessors (this is IMPLEMENTATION SUCKS!)
          #@ToDo Break on first
          MailProcessor.constants.each do |mp|
            m, email = ('MailProcessor::'+mp.to_s).classify.constantize.identify(m, email)
          end unless m.from_account?

          lead_name = m.from_account? ? email.to.first.name : email.from.first.name

          m.lead = Lead.get_or_create( m.lead_email, account, campaign, lead_name)
          m.lead.increment :step unless m.from_account?

          ScheduledMessage.delete_all message_id: m.message_id

          if m.is_more_recent? && m.lead.status != 'bounced'
            m.lead.last_contacted = m.date
            m.lead.status = (m.from_account?)? 'waiting_reply' : 'attention_needed'
          end

          m.lead.save
        end

        begin
          m.save
          email.label! label
          email.label! Campaign::CONTROL_LABEL
          done += 1
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{m.subject} <#{email.from_addrs.join(', ')}> <#{email.to_addrs.join(', ')}>"
        rescue Exception => e
          # Display failure message
          puts "\e[31m[!!]\e[0m  #{m.subject} <#{email.from_addrs.join(', ')}> <#{email.to_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          puts e.backtrace

          email.unread!
          email.remove_label! label
          email.remove_label! Campaign::CONTROL_LABEL
        end
      end
    end

    ENCODE_CONFIG = { external_encoding: [::Encoding::UTF_8, ::Encoding::ISO_8859_1],
                      invalid_characters: :transcode }
    def convert_from_gmail email
      message = {
          message_id: email.message_id.to_s.tr('<>', ''),
          subject:    email.subject,
          from_raw:   Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
          to_raw:     Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
          from:       email.from_addrs.first,
          to:         email.to_addrs.first,
          date:       (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil),
          countable:  true
      }

      # Its hard to get the right encoding,
      # body:(email.body.parts.first.body.to_s rescue email.body.to_s).gsub( /^From: .*@.*/m,'').strip.force_encoding('UTF-8'),
      # (e_body.respond_to? :decoded) ? e_body.decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip : email.body.decoded
      # (email.multipart? && !email.html_part.blank?)? email.html_part.body.decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip : ''
      #                                                                     encode('UTF-8','ISO-8859-1')
      text_part = email.multipart? ? (email.text_part ? email.text_part.body.decoded : nil) : email.body.decoded
      html_part = email.html_part ? email.html_part.body.decoded : nil

      message[:body]     = text_part.ensure_encoding('UTF-8', ENCODE_CONFIG).strip if text_part
      message[:body_raw] = html_part.ensure_encoding('UTF-8', ENCODE_CONFIG).strip if html_part

      self.new message
    end
  end
end
