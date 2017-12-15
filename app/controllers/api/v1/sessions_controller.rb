class Api::V1::SessionsController < ApplicationController
  def create

    query_params = {
      client_id: ENV["CLIENT_ID"],
      response_type: "code",
      redirect_uri: ENV["REDIRECT_URI"],
      scope: "user-library-read user-library-modify user-top-read user-modify-playback-state playlist-modify-public",
      show_dialog: true
    }
    url = "https://accounts.spotify.com/authorize/"
    redirect_to "#{url}?#{query_params.to_query}"
  end

  def show
    render json: my_user
  end
end
