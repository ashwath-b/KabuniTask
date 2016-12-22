class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  def require_login!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied, Not authorized for this operation" } ] }, status: 401
  end

  def generate_url(page, per_page, class_name, short_url_id = nil)
    if short_url_id.nil?
      "http://my-domain.com/short_urls?page=#{page}&per_page=#{per_page}"
    else
      "http://my-domain.com/short_urls/#{short_url_id}?page=#{page}&per_page=#{per_page}"
    end
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @user = User.find_by(auth_token: token)
    end
  end

end
