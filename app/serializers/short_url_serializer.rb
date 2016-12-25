class ShortUrlSerializer < ActiveModel::Serializer
  attributes :original_url, :shorty, :user_id, :visits_count

  belongs_to :user
  has_many :short_visits
  # def short_url
  #   "#{root_url}/#{shorty}"
  # end
end
