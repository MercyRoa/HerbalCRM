class Lead < ActiveRecord::Base
  has_many :messages, :order => "created_at"
  has_many :histories, :order => "created_at DESC"
  belongs_to :account

  scope :to_reply, where(automatic: false).order("updated_at DESC")
  
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
    logger.info " Buscando Lead #{name} #{email}"
    
    lead = self.find_by_email email
    
    if lead.nil?
      lead = self.make_from({first_name: name, email: email}, account)
    else
      lead.update_attribute(:first_name, name) if lead.first_name.empty? && !name.nil?
    end
    
    lead
  end
end
