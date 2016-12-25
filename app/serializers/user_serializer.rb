class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :token

  has_many :short_urls

  def token
    object.auth_token
  end
end
