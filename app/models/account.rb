
class Account < ActiveRecord::Base
  has_and_belongs_to_many :campaigns

  def to_s
    email
  end

  def connect_to_gmail &block
    Gmail.new(self.email, self.password, &block)
  end
  alias_method :gmail, :connect_to_gmail

  #Currently this is not used.
  def fetch_emails
    puts "Connecting to #{self.email}..."

    self.connect_to_gmail do |gmail|
      # Import Unread Inbox
      emails = gmail.inbox.emails(:unread)
      Message.import_emails_from_gmail(emails, self, nil, 'CRM')

      # Import Sent mail
      emails = gmail.sent.search('in:sent -label:CRM')
      Message.import_emails_from_gmail(emails, self, nil, 'CRM')
    end

    self.update_attribute :last_fetch_date, Time.now
  end

  # metodos estaticos
  class << self
    # Return gmail connection from first account, just for testing
    def gmail
      Account.first.gmail
    end
  end
end

