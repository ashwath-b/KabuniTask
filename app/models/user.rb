class User < ActiveRecord::Base
  attr_accessor :password
  before_validation :encrypt_password, :generate_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX } , uniqueness: { case_sensitive:false }
  validates :password, :confirmation => true, presence: true, :length => {:within => 6..20}
  validates_presence_of :password_salt, :password_hash
  validates_presence_of :auth_token, uniqueness: true

  has_many :short_urls

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  private

  def generate_token
    if self.new_record?
      begin
        self.auth_token = SecureRandom.hex
      end while self.class.exists?(auth_token: auth_token)
    end
  end
end
