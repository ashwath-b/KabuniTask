class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  def require_login!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied, Not authorized for this operation" } ] }, status: 401
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @user = User.find_by(auth_token: token)
    end
  end

end
