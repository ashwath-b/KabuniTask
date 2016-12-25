class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  def require_login!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied, Not authorized for this operation" } ] }, status: 401
  end

  def pagination_details(object)
  {
    current_page: object.current_page,
    next_page: object.next_page,
    prev_page: object.previous_page,
    per_page: object.per_page,
    total_pages: object.total_pages
  }
  end

  def merge_page_number_size
    unless params[:page]
      page = {}
      page[:number] = 1
      page[:size] = 5
      params.merge!(page: page)
    end
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @user = User.find_by(auth_token: token)
    end
  end

end
