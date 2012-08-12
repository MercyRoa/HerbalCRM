require 'test_helper'

class MailSequencesControllerTest < ActionController::TestCase
  setup do
    @mail_sequence = mail_sequences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mail_sequences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail_sequence" do
    assert_difference('MailSequence.count') do
      post :create, mail_sequence: @mail_sequence.attributes
    end

    assert_redirected_to mail_sequence_path(assigns(:mail_sequence))
  end

  test "should show mail_sequence" do
    get :show, id: @mail_sequence.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mail_sequence.to_param
    assert_response :success
  end

  test "should update mail_sequence" do
    put :update, id: @mail_sequence.to_param, mail_sequence: @mail_sequence.attributes
    assert_redirected_to mail_sequence_path(assigns(:mail_sequence))
  end

  test "should destroy mail_sequence" do
    assert_difference('MailSequence.count', -1) do
      delete :destroy, id: @mail_sequence.to_param
    end

    assert_redirected_to mail_sequences_path
  end
end
