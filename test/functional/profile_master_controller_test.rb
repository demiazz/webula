require 'test_helper'

class ProfileMasterControllerTest < ActionController::TestCase
  test "should get main_edit" do
    get :main_edit
    assert_response :success
  end

  test "should get main_save" do
    get :main_save
    assert_response :success
  end

  test "should get organization_edit" do
    get :organization_edit
    assert_response :success
  end

  test "should get organization_save" do
    get :organization_save
    assert_response :success
  end

  test "should get contacts_edit" do
    get :contacts_edit
    assert_response :success
  end

  test "should get contacts_save" do
    get :contacts_save
    assert_response :success
  end

  test "should get avatar_edit" do
    get :avatar_edit
    assert_response :success
  end

  test "should get avatar_save" do
    get :avatar_save
    assert_response :success
  end

  test "should get finish" do
    get :finish
    assert_response :success
  end

end
