class ScheduledMessage < ActiveRecord::Base
  belongs_to :account
  belongs_to :lead
  belongs_to :user
  order :scheduled, 'DESC'

  DEFAULT_SCHEDULE_TIME = 15.minutes
  before_create :set_default_data
  after_create :update_lead_details

  before_save :set_html_and_plain, :update_text_model

  scope :to_send, where(:sent => false).where("scheduled < ?", Time.now)

  def to_s
    "#{self.subject} to: #{self.to}"
  end

  def sent?
    self.sent
  end

  def set_html_and_plain
    unless self.body_html
      self.body_html = body
      self.body = html_to_text(body_html)
    end
  end

  # Update lead details while creating the sm
  def update_lead_details
    self.lead.update_attributes({
        :status           => :waiting_reply,
        :last_contacted   => self.created_at, #Time.now,
        :viewing_by       => nil
    })
  end

  def update_text_model
    self.body = self.body.gsub("{lead.name}", self.lead.name)
    self.body_html = self.body_html.gsub("{lead.name}", self.lead.name)
  end

  def self.send_all
    self.to_send.limit(15).each { |sm| sm.send_msg }
  end

  def send_msg
    puts " * Sending: #{self}"
    begin
      message = self
      m = self.account.gmail.deliver! do
        to message.to
        bcc message.bcc unless message.bcc.blank?
        subject message.subject

        #maybe this is throwing an error?
        text_part do
          content_type "text/plain; charset=utf-8"
          body message.body
        end
        html_part do
          content_type 'text/html; charset=UTF-8'
          body message.body_html + "<br/><br/>" + message.account.signature
        end
      end

      self.update_attributes! sent: true, message_id: m.message_id
      puts "\e[32m[OK]\e[0m"
    rescue Exception => e
      puts "\e[31m[!]\e[0m Error sending email"
      puts e.message
      #puts e.backtrace
    end
  end

  private
  def set_default_data
    self.scheduled = DEFAULT_SCHEDULE_TIME.from_now if self.scheduled.nil?
  end
end
