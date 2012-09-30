class ScheduledMessage < ActiveRecord::Base
  belongs_to :account
  belongs_to :lead

  DEFAULT_SCHEDULE_TIME = 15.minutes
  before_create :set_default_schedule

  scope :to_send, where(:sent => false).where("scheduled > ?", Time.new)

  def to_s
    self.subject
  end

  def sent?
    self.sent
  end

  def self.send_all
    self.to_send.each { |sm| sm.send_msg }
  end

  def send_msg
    puts " * Enviando: #{self}"
    begin
      self.account.gmail.delivery do
        to self.to
        subject self.subject
        text_part do
          body self.body
        end
      end

      self.lead.update_attributes({
        :status     => 'waiting-reply',
        :last_contacted => Time.new,
        :automatic  => false
      })
    rescue
      puts "\e[31m[!]\e[0m Error sending email"
    end
  end

  private
  def set_default_schedule
    self.scheduled = DEFAULT_SCHEDULE_TIME.from_now
  end
end
