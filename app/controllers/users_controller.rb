class UsersController < ApplicationController

  def login
    user = User.authenticate(params[:email], params[:password])
    if user
      render json: user, status: 200
    else
      invalid_login_attempt
    end
  end

  def sign_up
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: 200
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def invalid_login_attempt
    render json: { errors: [ { message:"Error with your login or password" }]}, status: 401
  end
end
