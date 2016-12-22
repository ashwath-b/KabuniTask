class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  def require_login!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied" } ] }, status: 401
  end

  def generate_url(page, per_page)
    "http://my-domain.com/short_urls?page=#{page}&per_page=#{per_page}"
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @user = User.find_by(auth_token: token)
    end
  end

end
