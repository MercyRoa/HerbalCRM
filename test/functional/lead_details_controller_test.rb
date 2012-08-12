require 'test_helper'

class LeadDetailsControllerTest < ActionController::TestCase
  setup do
    @lead_detail = lead_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lead_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lead_detail" do
    assert_difference('LeadDetail.count') do
      post :create, lead_detail: @lead_detail.attributes
    end

    assert_redirected_to lead_detail_path(assigns(:lead_detail))
  end

  test "should show lead_detail" do
    get :show, id: @lead_detail.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lead_detail.to_param
    assert_response :success
  end

  test "should update lead_detail" do
    put :update, id: @lead_detail.to_param, lead_detail: @lead_detail.attributes
    assert_redirected_to lead_detail_path(assigns(:lead_detail))
  end

  test "should destroy lead_detail" do
    assert_difference('LeadDetail.count', -1) do
      delete :destroy, id: @lead_detail.to_param
    end

    assert_redirected_to lead_details_path
  end
end
