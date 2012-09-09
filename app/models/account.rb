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
    
    puts "Conectandose"
    
    Gmail.new(self.email, self.password) do |gmail|
      total = gmail.inbox.emails(:unread).count
      puts "Importing #{total} messages, press Ctrl-C to abort...", '-'*80
      
      gmail.inbox.emails(:unread).each do |email|
        puts "procesando mensaje..."
        message              = {}
        message[:account_id] = self.id
        message[:message_id] = email.message_id.to_s.tr('<>', '').tr('/', '-')
        message[:subject]    = email.subject.to_s
        message[:from]       = Array(email.from).map { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", ")
        message[:to]         = Array(email.to).map   { |a| "#{a.name} <#{a.mailbox}@#{a.host}>" }.join(", ")
        message[:date]       = (Time.parse(email.date).strftime('%Y-%m-%dT%H:%M:%S%z') rescue nil)
        message[:body]       = (email.body.parts.first.body.to_s rescue email.body.to_s)
        message[:body_raw]   = email.body.to_s

        #Adjust body (Remove also all lines which start with ">" ? )
        message[:body].gsub!( /^From: .*@.*/m, '').strip

        begin
          email.label! "Bip-Bip"
          puts "\e[32m#{done.to_s.ljust(4)}\e[0m #{email.subject} <#{email.from_addrs.join(', ')}>"

          message[:lead_id] = Lead.get_or_create( email.from_addrs.first, self, email.from.first.name)
          
          m = Message.new message
          m.save
          
          done += 1
        rescue Exception => e
          # Display failure message
          puts "="*30+"- ERROR -"+"="*30
          puts "="*30
          puts "\e[31m[!]\e[0m  #{email.subject} <#{email.from_addrs.join(', ')}>"
          puts "     #{e.inspect}"
          errors << email
          email.unread!
        end

        puts "="*80
        puts errors.to_yaml
        puts "="*80
      end
    end
  end
end

