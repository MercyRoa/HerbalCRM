class Lead < ActiveRecord::Base
  has_many :messages, :order => "date DESC"
  has_many :scheduled_messages

  has_many :histories, :order => "created_at DESC"
  has_many :lead_details, :dependent => :destroy
  belongs_to :account
  belongs_to :campaign

  accepts_nested_attributes_for :lead_details

  scope :to_reply, where(automatic: false).order("updated_at DESC")

  def to_s
    return email if first_name.nil?
    "#{first_name} #{last_name}"
  end
  alias_method :name, :to_s

  def to_param
    "#{id}-#{name.parameterize}"
  end

  # User can be String (with email) or hash
  def self.make_from(lead, account = nil)
    account = Account.first if account.nil?
    
    if lead.class == String
      lead = { email: lead }
    end

    lead[:account_id] = account.id

    self.create lead
  end
  
  # Check if profile exist, and return it or create 
  # user:string email
  def self.get_or_create(email, account = nil, name = nil)
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
