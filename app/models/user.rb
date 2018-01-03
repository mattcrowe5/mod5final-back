class User < ApplicationRecord

  def access_token_expired?
    (Time.now - self.updated_at) > ENV["TIME"].to_i
  end
end
