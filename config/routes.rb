Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'sessions', to: 'sessions#create'
      post 'home', to: 'users#create'
      get 'current_user', to: 'logins#show'

      post 'fetch_user', to: 'users#show'
      post 'top_tracks', to: 'top_tracks#create'
      post 'top_artists', to: 'artists#create'
    end
  end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
