require 'time'
class Api::V1::ShowsController < ApplicationController

  def create
    show = Show.find_or_create_by(show_params)
    user_id = JWT.decode(params["token"], ENV["MY_SECRET"], ENV["EGGS"])[0]["user_id"]
    @user = User.find_by(id: user_id)

    if !@user.shows.include?(show)
      @user.shows << show
      @user.save
    end


    render json: @user.shows

  end

  def show
    # iterating through decoded to get to the access token and passing it into the header

    @concerts = []
    params['related_artists'].each do |artist|
      artist_hash = RestClient.get("https://api.songkick.com/api/3.0/search/artists.json?apikey=#{ENV["SONG_KEY"]}&query=#{artist['name']}")
      related_artists_params = JSON.parse(artist_hash.body)
      id = related_artists_params['resultsPage']['results']['artist'][0]["id"]
      shows_hash = RestClient.get("https://api.songkick.com/api/3.0/artists/#{id}/calendar.json?apikey=#{ENV["SONG_KEY"]}")
      shows = JSON.parse(shows_hash)["resultsPage"]['results']['event']
      if shows != nil
        filtered_shows = shows.map do |show|
          if show['venue']['metroArea']['displayName'] === params['city']
            {concert: show["displayName"], venue: show['venue']['displayName'], date: Time.parse(show["start"]["date"]).strftime("%m/%d/%y"), time: Time.parse(show["start"]["time"]).strftime("%l %P"), link: show['uri'], artist: show['performance'][0]['displayName'], photo: artist['photo']}
          end
        end
        @concerts.concat(filtered_shows.compact)
      end

    end


    # making the fetch request to the spotify api and parsing it
    render json: {shows: @concerts}
    # rendering to the back end so the front end can take in the data
  end

  private
  def show_params
    {
      venue: params["show"]["venue"],
      date: params["show"]["date"],
      time: params["show"]["time"],
      name: params["show"]["concert"],
      link: params["show"]["link"],
      artist: params["show"]["artist"],
      photo: params["show"]["photo"]
    }
  end

end
