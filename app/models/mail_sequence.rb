class MailSequence < ActiveRecord::Base
  belongs_to :campaign
  validates_presence_of :step, :subject
end
