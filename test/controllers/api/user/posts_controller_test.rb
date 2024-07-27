require "test_helper"

class Api::User::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_user_posts_create_url
    assert_response :success
  end

  test "should get edit" do
    get api_user_posts_edit_url
    assert_response :success
  end

  test "should get delete" do
    get api_user_posts_delete_url
    assert_response :success
  end

  test "should get show" do
    get api_user_posts_show_url
    assert_response :success
  end
end
