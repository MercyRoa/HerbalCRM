#encoding: UTF-8
#require 'iconv'
def force_utf(s)
    #Iconv.conv('UTF-8//IGNORE', 'UTF-8', s + ' ')[0..-2]
end

class Account < ActiveRecord::Base
  def gmail
    Gmail.new(self.email, self.password)
  end

  def fetch_emails
    done   = 0
    total  = 0
    errors = []
    
    puts "Connecting..."
    
    Gmail.new(self.email, self.password) do |gmail|
      total = gmail.inbox.emails(:unread).count
      puts "Importing #{total} messages, press Ctrl-C to abort...", '-'*80

      # Import Inbox
      gmail.inbox.emails(:unread).each do |email|
        puts "Processing message..."
        m = Message.convert_from_gmail email
        m.account_id = self.id
        m.lead_id    = Lead.get_or_create( email.from_addrs.first, self, email.from.first.name).id

        begin
          email.label! "Bip-Received"
          m.save
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{email.subject} <#{email.from_addrs.join(', ')}>"
          done += 1
        rescue Exception => e
          # Display failure message
          puts "\e[31m[!]\e[0m  #{email.subject} <#{email.from_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          errors << email
          email.unread!
        end

        puts "="*80
        puts errors.to_yaml
        puts "="*80
      end

      # Import Sent
      done = 0
      opts = {
          after: (self.last_fetch_date - 1.day), # Technically, this is not needed
          query: ['X-GM-RAW', 'in:sent -label:Bip-Sent']  #in:sent isnt needed
      }
      total = gmail.mailbox('[Gmail]/Sent Mail').emails(opts).count
      puts "Importing #{total} sent messages, press Ctrl-C to abort...", '-'*80
      gmail.mailbox('[Gmail]/Sent Mail').emails(opts).each do |email| # Why .each???
        puts "Processing message..."
        m = Message.convert_from_gmail email
        m.account_id = self.id
        m.lead_id    = Lead.get_or_create( email.to_addrs.first, self, email.to.first.name).id
        begin
          email.label! "Bip-Sent"
          m.save
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{email.subject} <#{email.from_addrs.join(', ')}>"
          done += 1
        rescue Exception => e
          # Display failure message
          puts "\e[31m[!]\e[0m  #{email.subject} <#{email.from_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          errors << email
          email.unread!
        end
      end

      #self.update_attribute :last_fetch_date, Time.now
    end
  end
end

