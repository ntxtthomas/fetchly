require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get show" do
    user = users(:one)
    get user_url(user)
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should get create" do
    post users_url, params: { user: { first_name: "Test", last_name: "User", email: "test@example.com" } }
    assert_response :redirect
  end

  test "should get edit" do
    user = users(:one)
    get edit_user_url(user)
    assert_response :success
  end

  test "should get update" do
    user = users(:one)
    patch user_url(user), params: { user: { first_name: "Updated" } }
    assert_response :redirect
  end

  test "should get destroy" do
    user = users(:three)  # Use user with no bookings
    delete user_url(user)
    assert_response :redirect
  end
end
