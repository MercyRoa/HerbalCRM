class ScheduledMessage < ActiveRecord::Base
  belongs_to :account
  belongs_to :lead
  order :scheduled, 'DESC'

  DEFAULT_SCHEDULE_TIME = 15.minutes
  before_create :set_default_schedule
  after_create :update_lead_details

  scope :to_send, where(:sent => false).where("scheduled < ?", Time.now)

  def to_s
    self.subject
  end

  def sent?
    self.sent
  end

  # Update lead details while creating the sm
  def update_lead_details
    self.lead.update_attributes({
        :status     => 'waiting-reply',
        :last_contacted => self.scheduled, #Time.now,
        :automatic  => false
    })
  end

  def self.send_all
    self.to_send.each { |sm| sm.send_msg }
  end

  def send_msg
    puts " * Sending: #{self}"
    begin
      message = self
      m = self.account.gmail.deliver! do
        to message.to
        subject message.subject
        body message.body
      end

      self.update_attributes! sent: true, message_id: m.message_id
      puts "\e[32m[OK]\e[0m"
    rescue Exception => e
      puts "\e[31m[!]\e[0m Error sending email"
      puts e.message
    end
  end

  private
  def set_default_schedule
    self.scheduled = DEFAULT_SCHEDULE_TIME.from_now
  end
end
