class SpotifyAdapter

  URLS={
    auth:"https://accounts.spotify.com/api/token",
    me:"https://api.spotify.com/v1/me"
  }

  def self.body_params
    body = {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV["CLIENT_SECRET"]
    }
  end

  def self.refresh_access_token(refresh_token)
    body = body_params.dup
    body[:grant_type] = "refresh_token"
    body[:refresh_token] = refresh_token

    auth_params = authorize(body)
    auth_params["access_token"]
  end

  def self.login(code)

    body = body_params.dup
    body[:grant_type] = "authorization_code"
    body[:code] = code
    body[:redirect_uri] = ENV['REDIRECT_URI']

    authorize(body)
  end

  def self.authorize(body)
    auth_response = RestClient.post(URLS[:auth], body)
    JSON.parse(auth_response.body)
  end

  def self.getUserData(access_token)

    header = {
      Authorization: "Bearer #{access_token}"
    }

    user_response = RestClient.get(URLS[:me], header)

    JSON.parse(user_response.body)
  end

  def self.nilCheck(data)
    data === nil ? a = "n/a" : a = data
    a
  end

  def self.timeCheck(data)
    data === nil ? a = "n/a" : a = Time.parse(data).strftime("%l %P")
    a
  end

  def self.dateCheck(data)
    data === nil ? a = "n/a" : a = Time.parse(data).strftime("%m/%d/%y")
    a
  end

end
