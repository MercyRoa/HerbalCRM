class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  #force_ssl
  private

  helper_method :current_user

  before_filter :set_current_user

  def set_current_user
    User.current_user = current_user
  end
end
