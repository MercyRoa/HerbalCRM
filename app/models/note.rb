class Note < ActiveRecord::Base
  order :id, :DESC
  belongs_to :lead
  belongs_to :user, :foreign_key => :assigned_to
  belongs_to :creator, :class_name => 'User', :foreign_key => :created_by

  before_validation lambda{ self.created_by = User.current_user.id }
end
