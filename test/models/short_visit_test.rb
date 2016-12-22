require 'test_helper'

class ShortVisitTest < ActiveSupport::TestCase
  setup do
    @short_url = short_urls(:one)
    @short_visit = short_visits(:one)
  end

  test "should not create short visit with empty short_url_id or visitor_ip" do
    short_visit = ShortVisit.new(:short_url_id => nil, :visitor_ip => nil)
    assert_not short_visit.valid?
    assert_presence(short_visit, :short_url_id)
    assert_presence(short_visit, :visitor_city)
  end
end
