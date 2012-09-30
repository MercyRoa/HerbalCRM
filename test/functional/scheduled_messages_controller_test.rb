require 'test_helper'

class ScheduledMessagesControllerTest < ActionController::TestCase
  test "should get send_all" do
    get :send_all
    assert_response :success
  end

end
