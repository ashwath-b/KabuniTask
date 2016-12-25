require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
  end

  test "should not login user with invalid email" do
    get :login, {email: nil, password: 12345678}
    assert_response 401
  end

  test "should login and respond with access_token in json" do
    get :login, {email: 'user_1@example.com', password: 12345678}
    assert_response :success
    assert_equal Mime::JSON, response.content_type
    result = json(response.body)
    access_token = result[:data][:attributes][:token]
    assert_equal access_token, @user.auth_token
  end

  test "Shouldn't create user with empty email" do
    post :sign_up, {email: '', name: 'user_3'}
    assert_response :unprocessable_entity
  end

  test "Shouldn't create user with empty password" do
    post :sign_up, {email: 'user_3@example.com', name: 'user_3', password: nil}
    assert_response :unprocessable_entity
  end

  test "Shouldn't create user with unmatching password_confirmation" do
    post :sign_up, {email: 'user_3@example.com', name: 'user_3', password: 12345678, password_confirmation: 1245637}
    assert_response :unprocessable_entity
  end

  test "should create user" do
    assert_difference('User.count') do
      post :sign_up, {email: 'user_3@example.com', name: 'user_3', password: 12345678, password_confirmation: 12345678}
    end
    assert_response :success
    assert_equal Mime::JSON, response.content_type
  end

  test "should route to login" do
    assert_routing '/login', {controller: "users", action: "login"}
  end

  test "should route to signup" do
    assert_routing({ method: 'post', path: '/sign_up' }, {controller: "users", action: "sign_up"})
  end

end
