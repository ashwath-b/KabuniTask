class ShortVisitSerializer < ActiveModel::Serializer
  attributes :visitor_ip, :visitor_city, :visitor_state, :visitor_country_iso2

  belongs_to :short_url
end
