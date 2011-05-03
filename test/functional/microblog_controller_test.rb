require 'test_helper'

class MicroblogControllerTest < ActionController::TestCase
  test "should get global_feed" do
    get :global_feed
    assert_response :success
  end

  test "should get local_feed" do
    get :local_feed
    assert_response :success
  end

  test "should get private_feed" do
    get :private_feed
    assert_response :success
  end

  test "should get followings_feed" do
    get :followings_feed
    assert_response :success
  end

  test "should get followers_feed" do
    get :followers_feed
    assert_response :success
  end

  test "should get followings" do
    get :followings
    assert_response :success
  end

  test "should get followers" do
    get :followers
    assert_response :success
  end

  test "should get add_following" do
    get :add_following
    assert_response :success
  end

  test "should get create_post" do
    get :create_post
    assert_response :success
  end

  test "should get delete_post" do
    get :delete_post
    assert_response :success
  end

end
