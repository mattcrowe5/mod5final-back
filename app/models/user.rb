class User < ApplicationRecord

  def access_token_expired?
    (Time.now - self.updated_at) > 3300
  end

  def refresh_access_token
   # Check if user's access token has expired
   if access_token_expired?
     #Request a new access token using refresh token
     #Create body of request
     body = {
       grant_type: "refresh_token",
       refresh_token: self.refresh_token,
       client_id: ENV['CLIENT_ID'],
       client_secret: ENV["CLIENT_SECRET"]
     }
     # Send request and updated user's access_token
     auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
     auth_params = JSON.parse(auth_response)
     self.update(access_token: auth_params["access_token"])
   else
     puts "Current user's access token is still valid"
   end
 end
end
