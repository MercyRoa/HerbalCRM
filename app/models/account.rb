
class Account < ActiveRecord::Base
  def connect_to_gmail &block
    Gmail.new(self.email, self.password, &block)
  end

  def fetch_emails
    puts "Connecting to #{self.email}..."

    self.connect_to_gmail do |gmail|
      # Import Unread Inbox
      emails = gmail.inbox.emails(:unread)
      Message.import_emails_from_gmail(emails, self, 'BipR')

      # Import Sent mail
      emails = gmail.sent.search('in:sent -label:Bip-Sent')
      Message.import_emails_from_gmail(emails, self, 'BipS')
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

