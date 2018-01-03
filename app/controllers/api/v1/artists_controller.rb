class Api::V1::ArtistsController < ApplicationController
  def create
    decoded = JWT.decode(my_user.access_token, ENV["MY_SECRET"], ENV["EGGS"])
    # taking the access token stored in user and decoding it

    header = {'Authorization': "Bearer " + decoded[0]["token"]}
    # iterating through decoded to get to the access token and passing it into the header
    top_artists_response = RestClient.get("https://api.spotify.com/v1/me/top/artists", header)
    top_artists_params = JSON.parse(top_artists_response.body)
    # making the fetch request to the spotify api and parsing it
    render json: {top_artists: top_artists_params}
    # rendering to the back end so the front end can take in the data
  end

  def show
    decoded = JWT.decode(my_user.access_token, ENV["MY_SECRET"], ENV["EGGS"])
    # taking the access token stored in user and decoding it
    header = {'Authorization': "Bearer " + decoded[0]["token"]}
    # iterating through decoded to get to the access token and passing it into the header
    related_artists_response = RestClient.get("https://api.spotify.com/v1/artists/#{params['artist_id']}/related-artists", header)
    related_artists_params = JSON.parse(related_artists_response.body)
    artist_names = related_artists_params["artists"].map do |artist|
      {name: artist["name"], photo: artist['images'][0]['url']}
    end

    artist_names = artist_names.slice(0,8)
    # making the fetch request to the spotify api and parsing it
    render json: {related_artists: artist_names, city: params['city']}
    # rendering to the back end so the front end can take in the data
  end
end
