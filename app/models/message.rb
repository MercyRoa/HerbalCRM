# encode: UTF-8

class Message < ActiveRecord::Base
  order :date, 'DESC'

  belongs_to :lead
  belongs_to :account

  validates_uniqueness_of :message_id
  before_save lambda { self.from_account = true if self.from_account? }
  after_save :update_lead_counters
  after_destroy :update_lead_counters

  MAILER_DAEMONS = ['mailer-daemon@googlemail.com']

  def to_s
    body.gsub( /^From: .*@.*/m, '').strip
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
    def import_emails_from_gmail(emails, account, label)
      done = 0
      puts "Importing #{emails.count} messages, press Ctrl-C to abort...", '-'*80
      emails.each do |email|
        puts "Processing message... #{email.subject}"
        m = convert_from_gmail email
        m.account = account

        # ToDo refactor this ugly piece of code!
        if m.is_mailer_daemon?
          m.countable = false
          m.lead = Lead.get_or_create( extract_email(m.body), account)
          m.lead.increment :bounce
          m.lead.status = 'bounced'
          m.lead.automatic = false

          m.lead.save
        else
          lead_name = m.from_account? ? email.to.first.name : email.from.first.name
          m.lead = Lead.get_or_create( m.lead_email, account, lead_name)
          m.lead.increment :step unless m.from_account?

          if m.is_more_recent? && m.lead.status != 'bounced'
            m.lead.last_contacted = m.date
            m.lead.status = (m.from_account?)? 'waiting_reply' : 'attention_needed'
          end

          m.lead.save
        end

        begin
          email.label! label
          m.save
          done += 1
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{m.subject} <#{email.from_addrs.join(', ')}> <#{email.to_addrs.join(', ')}>"
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
        from_raw:   Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
        to_raw:     Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", "),
        from:       email.from_addrs.first,
        to:         email.to_addrs.first,
        date:       (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil),
        #body:       (email.body.parts.first.body.to_s rescue email.body.to_s).gsub( /^From: .*@.*/m, '').strip.force_encoding('UTF-8'),
        body:       ((email.multipart?)? email.text_part : email.body).decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip,
        body_raw:   (email.multipart?)? email.html_part.body.decoded.force_encoding("ISO-8859-1").encode("UTF-8").strip : '',
        countable:  true
      })
    end


  end
end
