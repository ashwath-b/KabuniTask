class ShortUrl < ActiveRecord::Base

  before_validation :generate_shorty
  validates_presence_of :user_id
  validates :original_url, presence: true, format: {with: URI::regexp(%w(http https)), message: "URL must start with http:// or https://"}, uniqueness: {case_sensitive:false, scope: :user_id}
  validates :shorty, uniqueness: true, presence: true
  belongs_to :user
  has_many :short_visits #, :dependent => :destroy

  def update_short_visit(ip)
    self.short_visits.build(:visitor_ip => ip)
    if save
      self.visits_count += 1
      save
    end
  end

  private

  def generate_shorty
    if self.new_record?
      begin
        var = Time.now.to_s
        self.shorty = Digest::MD5.hexdigest(var).slice(0..6)
      end while self.class.exists?(shorty: shorty)
    end
  end
end
