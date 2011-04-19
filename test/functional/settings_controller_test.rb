require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  test "should get avatar_edit" do
    get :avatar_edit
    assert_response :success
  end

  test "should get avatar_update" do
    get :avatar_update
    assert_response :success
  end

  test "should get profile_edit" do
    get :profile_edit
    assert_response :success
  end

  test "should get profile_update" do
    get :profile_update
    assert_response :success
  end

end
