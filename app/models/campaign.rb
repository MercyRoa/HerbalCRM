class Campaign < ActiveRecord::Base
  has_many :mail_sequences, order: 'step'
end
