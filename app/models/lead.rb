class Lead < ActiveRecord::Base
  has_many :messages, :order => "date DESC"
  has_many :scheduled_messages, :order => 'id DESC'

  has_many :histories, :order => "created_at DESC"
  has_many :lead_details, :dependent => :destroy
  belongs_to :account
  belongs_to :campaign

  accepts_nested_attributes_for :lead_details

  scope :to_reply, where(automatic: false).order("updated_at DESC")
  scope :automated, where(automatic: true, status: :attention_needed)

  def to_s
    return email if first_name.nil?
    "#{first_name} #{last_name}"
  end
  alias_method :name, :to_s

  # this creates the friendly url
  def to_param
    "#{id}-#{name.parameterize}"
  end

  def process_automate
    next_message = self.campaign.mail_sequences.where(step: self.step).first
    if next_message
      ScheduledMessage.new(
          account_id: self.account_id,
          lead_id: self.id,
          to: self.email,
          subject: next_message.subject,
          body: next_message.body_text,
          body_html: next_message.body_html
      ).save
    else
      self.update_attribute :automated, false
    end
  end

  class << self
    # it's okey to have this here or should be made on each message received?
    def create_messages_for_all_automated
      Lead.automated.each do |l|
        l.process_automate
      end
    end

    # User can be String (with email) or hash
    def make_from(lead, account = nil)
      account = Account.find account if account.kind_of? Fixnum
      account = Account.first if account.nil?

      if lead.class == String
        lead = { email: lead }
      end

      lead[:account_id] = account.id

      self.create lead
    end

    # Check if profile exist, and return it or create
    # user:string email
    def get_or_create(email, account = nil, name = nil)
      if name.is_a? Hash
        # ToDo: more info suplied... fix array
      end
      logger.info " Buscando Lead #{name} #{email}"
      lead = self.find_by_email email

      if lead.nil?
        lead = self.make_from({first_name: name, email: email}, account)
      else
        lead.update_attribute(:first_name, name) if lead.first_name.nil? && !name.nil?
      end

      lead
    end
  end
end
