require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase

  setup do
    @user = users(:one)
    @short_url = short_urls(:one)
  end
  should validate_presence_of(:user_id)
  should validate_presence_of(:original_url)

  test "Should not create short_url with empty user_id or shorty or original_url" do
    short_url = ShortUrl.new(user_id: nil, shorty: nil, original_url: nil)
    assert_not short_url.valid?
    assert_presence(@short_url, :shorty)
  end

  test "should belong to user" do
    assert_equal @short_url.user, @user
  end

  test "Should increment visits_count" do
    before_value = @short_url.visits_count
    short_visit = @short_url.update_short_visit("1.2.3.4")
    assert_equal @short_url.visits_count, before_value + 1
  end
end
