require 'test_helper'

class ShortUrlsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @short_url = short_urls(:one)
    request.headers["HTTP_AUTHORIZATION"] = "Token token=\"#{@user.auth_token}\""
    request.headers
  end

  test "should get index in json and set user & short_url" do
    get :index
    assert_response :success
    assert_equal Mime::JSON, response.content_type
    assert_not_nil assigns(:short_urls)
    assert_not_nil assigns(:user)
  end

  test "should create short_url and responds in json" do
    assert_difference('ShortUrl.count') do
      post :create, { original_url: "http://example_test.com"}
    end
    assert_equal Mime::JSON, response.content_type
    assert_response 201
  end

  test "Should only show owner short_url and responds in json" do
    get :show, id: 3
    assert_response 204
    get :show, id: @short_url
    assert_equal Mime::JSON, response.content_type
    assert_response 200
  end

  test "should update short_url by only owner" do
    put :update, id: @short_url, short_url: { original_url: @short_url.original_url, shorty: @short_url.shorty}
    assert_response 204
    short_url = short_urls(:three)
    put :update, id: short_url.id, short_url: { original_url: short_url.original_url, shorty: short_url.shorty}
    result = json(response.body)
    text = result[:message]
    assert_equal text, "No short_url with given id"
  end

  test "should destroy short_url" do
    assert_difference('ShortUrl.count', -1) do
      delete :destroy, id: @short_url
    end
    assert_response 204
  end

  test "Should redirect_to original_url" do
    get :out_url, shorty: @short_url.shorty
    assert_redirected_to @short_url.original_url
  end

  test "should route to index" do
    assert_routing '/short_urls', {controller: "short_urls", action: "index"}
  end

  test "should route to create" do
    assert_routing({ method: 'POST', path: '/short_urls' }, {controller: "short_urls", action: "create"})
  end

  test "should route to update" do
    assert_routing({ method: 'PATCH', path: '/short_urls/1' }, {controller: "short_urls", action: "update", id: 1.to_s})
  end

  test "should route to delete" do
    assert_routing({ method: 'DELETE', path: '/short_urls/1' }, {controller: "short_urls", action: "destroy", id: 1.to_s})
  end
end
