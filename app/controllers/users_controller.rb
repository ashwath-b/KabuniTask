class UsersController < ApplicationController

  def login
    user = User.authenticate(params[:email], params[:password])
    if user
      auth_token = user.auth_token
      render json: {auth_token: auth_token, message: "Logged in"}
    else
      invalid_login_attempt
    end
  end

  def sign_up
    @user = User.new(user_params)
    if @user.save
      user = {}
      user[:name] = @user.name
      user[:email] = @user.email
      user[:access_token] = @user.auth_token
      user[:message] = "Successfully Signed up"
      render json: user, status: 200
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def invalid_login_attempt
    render json: { errors: [ { detail:"Error with your login or password" }]}, status: 401
  end
end
