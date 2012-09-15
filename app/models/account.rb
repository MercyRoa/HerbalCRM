
class Account < ActiveRecord::Base
  def gmail
    Gmail.new(self.email, self.password)
  end

  def fetch_emails
    done = 0
    
    puts "Connecting to #{self.email}..."

    Gmail.new(self.email, self.password) do |gmail|
      emails = gmail.inbox.emails(:unread)
      puts "Importing #{emails.count} messages, press Ctrl-C to abort...", '-'*80

      # Import Inbox
      emails.each do |email|
        puts "Processing message..."
        m = Message.convert_from_gmail email
        m.account_id = self.id
        m.lead_id    = Lead.get_or_create( email.from_addrs.first, self, email.from.first.name).id

        begin
          email.label! "Bip-Received"
          m.save
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{m.subject} <#{email.from_addrs.join(', ')}>"
          done += 1
        rescue Exception => e
          # Display failure message
          puts "\e[31m[!]\e[0m  #{m.subject} <#{email.from_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          email.unread!
          email.remove_label! 'Bip-Received'
        end
      end

      # Import Sent
      done = 0
      emails = gmail.sent.search('in:sent -label:Bip-Sent')
      puts "Importing #{emails.count} sent messages, press Ctrl-C to abort...", '-'*80
      emails.each do |email| # Why .each???
        puts "Processing message... #{email.subject}"
        m = Message.convert_from_gmail email
        m.account_id = self.id
        m.lead_id    = Lead.get_or_create( email.to_addrs.first, self, email.to.first.name).id
        begin
          email.label! "Bip-Sent"
          m.save
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{m.subject} <#{email.from_addrs.join(', ')}>"
          done += 1
        rescue Exception => e
          # Display failure message
          puts "\e[31m[!]\e[0m  #{m.subject} <#{email.from_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          email.unread!
          email.remove_label! 'Bip-Sent'
        end
      end

      #self.update_attribute :last_fetch_date, Time.now
    end
  end
end

