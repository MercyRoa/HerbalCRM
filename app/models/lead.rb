class Lead < ActiveRecord::Base
  has_many :messages, :order => "date DESC"
  has_many :scheduled_messages, :order => 'id DESC'

  has_many :histories, :order => "created_at DESC"
  has_many :lead_details, :dependent => :destroy
  belongs_to :account
  belongs_to :campaign
  belongs_to :user, :foreign_key => "assigned_to"

  after_save :send_mail_if_assigned

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
    "#{id}-#{(email.sub('@','-at-')).parameterize}"
  end

  #### After Save
  def send_mail_if_assigned
    if assigned_to_changed?
      lead = self
      url = Rails.application.routes.url_helpers.lead_url(self,
              host: HerbalCRM::Application.config.action_mailer.default_url_options[:host])
      self.account.gmail.deliver! do
        to lead.user.email
        subject "HerbalCRM lead #{lead} has been assigned to you"
        body "Please go to #{url}"
      end
    end
  end

  def process_automate
    return false if self.campaign.nil?

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
      self.update_attribute :automatic, false
    end
  end

  class << self
    # it's okey to have this here or should be made on each message received?
    def generate_automated_messages_for_all
      Lead.automated.each do |l|
        l.process_automate
      end
    end

    # User can be String (with email) or hash
    def make_from(lead, account = nil, campaign = nil)
      account = Account.find account if account.kind_of? Fixnum
      account = Account.first if account.nil?

      campaign = Campaign.find campaign if campaign.kind_of? Fixnum

      if lead.class == String
        lead = { email: lead }
      end

      lead[:account_id] = account.id
      lead[:campaign_id] = campaign.id unless campaign.nil?

      self.create lead
    end

    # Check if profile exist, and return it or create
    # user:string email
    def get_or_create(email, account = nil, campaign = nil, name = nil)
      if name.is_a? Hash
        # ToDo: more info suplied... fix array
      end

      logger.info " Buscando Lead #{name} <#{email}>"
      email = email.strip.downcase
      lead = self.find_by_email email

      params = {}
      if name
        name = name.strip.titleize.split(' ', 2)
        params[:first_name] = name.first
        params[:last_name] = name.last if (name.size == 2)
      end

      if lead.nil?
        puts " --> Creando Lead"
        lead = self.make_from(params.merge({email: email}), account, campaign)
      else
        lead.update_attributes(params) if lead.first_name.nil? && !name.nil?
        puts " --> Lead Existente"
      end

      lead
    end
  end
end
