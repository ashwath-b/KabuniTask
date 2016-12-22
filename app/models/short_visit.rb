class ShortVisit < ActiveRecord::Base
  require 'net/http'

  belongs_to :short_url
  validates_presence_of :short_url_id, :visitor_ip
  validates :visitor_ip, presence: true, uniqueness: { scope: :short_url_id, message: "Not a new user"}
  before_validation :update_info

  def update_info
    if self.new_record?
      response = Net::HTTP.get(URI.parse("http://freegeoip.net/json/#{self.visitor_ip}"))
      result = JSON.parse(response)
      self.visitor_city = result["city"]
      self.visitor_state = result["region_name"]
      self.visitor_country_iso2 = result["country_code"]
    end
  end

end
