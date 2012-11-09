class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  #force_ssl
  private

  helper_method :current_user
end
