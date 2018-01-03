class User < ApplicationRecord
  has_many :user_shows
  has_many :shows, through: :user_shows

  def access_token_expired?
    (Time.now - self.updated_at) > ENV["TIME"].to_i
  end
end
