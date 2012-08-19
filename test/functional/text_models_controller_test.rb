require 'test_helper'

class TextModelsControllerTest < ActionController::TestCase
  setup do
    @text_model = text_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:text_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create text_model" do
    assert_difference('TextModel.count') do
      post :create, text_model: @text_model.attributes
    end

    assert_redirected_to text_model_path(assigns(:text_model))
  end

  test "should show text_model" do
    get :show, id: @text_model.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @text_model.to_param
    assert_response :success
  end

  test "should update text_model" do
    put :update, id: @text_model.to_param, text_model: @text_model.attributes
    assert_redirected_to text_model_path(assigns(:text_model))
  end

  test "should destroy text_model" do
    assert_difference('TextModel.count', -1) do
      delete :destroy, id: @text_model.to_param
    end

    assert_redirected_to text_models_path
  end
end
