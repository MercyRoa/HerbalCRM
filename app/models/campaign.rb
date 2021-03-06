class Campaign < ActiveRecord::Base
  validates_presence_of :label

  scope :active, where(status: true)

  has_many :mail_sequences, order: 'step'
  has_and_belongs_to_many :accounts
  has_and_belongs_to_many :text_models
  accepts_nested_attributes_for :accounts

  def all_text_models
    (text_models + TextModel.global).uniq
  end

  CONTROL_LABEL = 'CRM'

  def fetch_emails
    puts "#{'='*15} Campaign #{name}    -    Query: #{search_query} #{'='*15}"

    accounts.each do |account|
      puts "Connecting to #{account.email}..."

      account.connect_to_gmail do |gmail|
        # Import Unread Inbox
        emails = gmail.inbox.search("#{search_query} -label:#{CONTROL_LABEL}")
        Message.import_emails_from_gmail(emails, account, self, label)

        # Import Sent mail
        # is:unread shouldn't be used on send email
        self.search_query = '' if self.search_query == 'is:unread'
        query = "in:sent #{search_query} -label:#{CONTROL_LABEL}"
        puts "Query: #{query}"
        emails = gmail.sent.search(query)
        Message.import_emails_from_gmail(emails, account, self, label)
      end
    end


    self.update_attribute :last_fetch_date, Time.now
  end

  # metodos estaticos
  class << self
    def fetch_all
      Campaign.active.each do |c|
        attemps = 0
        begin
          c.fetch_emails
        rescue => e
          puts "Error fetching email from #{c.name}"
          puts e.message
          sleep 5
          attemps+=1
          retry if attemps < 3
        end
      end
    end
  end
end
