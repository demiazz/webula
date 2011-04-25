require 'test_helper'

class FriendshipControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get requests_to" do
    get :requests_to
    assert_response :success
  end

  test "should get requests_from" do
    get :requests_from
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get mutual_friends" do
    get :mutual_friends
    assert_response :success
  end

  test "should get not_mutual_friends" do
    get :not_mutual_friends
    assert_response :success
  end

  test "should get add_friend" do
    get :add_friend
    assert_response :success
  end

  test "should get confirm_friend" do
    get :confirm_friend
    assert_response :success
  end

  test "should get refuse_friend" do
    get :refuse_friend
    assert_response :success
  end

  test "should get remove_friend" do
    get :remove_friend
    assert_response :success
  end

end
