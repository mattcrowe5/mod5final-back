class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create

    # body = {
    #   grant_type: "authorization_code",
    #   code: params[:code],
    #   redirect_uri: ENV["REDIRECT_URI"],
    #   client_id: ENV["CLIENT_ID"],
    #   client_secret: ENV["CLIENT_SECRET"]
    # }
    #
    # #get access and refresh tokens
    # auth_response = RestClient.post("https://accounts.spotify.com/api/token", body)
    # auth_params = JSON.parse(auth_response.body)
    #
    #
    # header = {
    #   Authorization: "Bearer #{auth_params["access_token"]}"
    # }
    #
    # #get user information
    # user_response = RestClient.get('https://api.spotify.com/v1/me', header)
    # user_data = JSON.parse(user_response.body)
    #
    # #with the results from Spotify, create the user in database
    # @user = User.find_or_create_by(
    #   username: user_params["id"],
    #   display_name: user_params["display_name"],
    #   spotify_url: user_params["external_urls"]["spotify"],
    #   href: user_params["href"],
    #   uri: user_params["uri"]
    # )
    #
    # #Saving the access token as a payload and encrpyting it
    # payload = {:access_token => auth_params["access_token"]}
    # refresh_payload = {:refresh_token => auth_params["refresh_token"]}
    # token = JWT.encode(payload, ENV["MY_SECRET"], ENV["EGGS"])
    # refresh_token = JWT.encode(refresh_payload, ENV["MY_SECRET"], ENV["EGGS"])
    #
    # #Updating the user with this information
    # @user.update(
    #   access_token: token,
    #   refresh_token: refresh_token
    # )
    #
    #
    # jwt_payload = {:user_id => @user.id}
    # jwt = JWT.encode jwt_payload, ENV["MY_SECRET"], ENV["EGGS"]
    # serialized_user = UserSerializer.new(@user).attributes
    # render json: {currentUser: serialized_user, code: jwt}

    auth_params = SpotifyAdapter.login(params[:code])
    user_data = SpotifyAdapter.getUserData(auth_params["access_token"])

    user = User.find_or_create_by(user_params(user_data))

    img_url = user_data["images"][0] ? user_data["images"][0]["url"] : nil

    encodedAccess = issue_token({token: auth_params["access_token"]})
    encodedRefresh = issue_token({token: auth_params["refresh_token"]})

    user.update(profile_img_url: img_url,access_token: encodedAccess,refresh_token: encodedRefresh)

    render json: user_with_token(user)


  end

  def show
    encrypted_id = params["jwt"]
    user_id = JWT.decode(encrypted_id, ENV["MY_SECRET"], ENV["EGGS"])[0]["user_id"]
    @user = User.find_by(id: user_id)

    jwt_payload = {:user_id => @user.id}
    jwt = JWT.encode jwt_payload, ENV["MY_SECRET"], ENV["EGGS"]
    serialized_user = UserSerializer.new(@user).attributes
    render json: {currentUser: serialized_user, code: jwt}
  end

  private
  def user_with_token(user)
    payload = {user_id: user.id}
    jwt = issue_token(payload)
    serialized_user = UserSerializer.new(user).attributes
    # { token: token, currentUser: newUser }
    {currentUser: serialized_user, code: jwt }
  end

  def user_params(user_data)
    params = {
      username: user_data["id"],
      display_name: user_data["display_name"],
      spotify_url: user_data["external_urls"]["spotify"],
      href: user_data["href"],
      uri: user_data["uri"]
    }
  end

end
