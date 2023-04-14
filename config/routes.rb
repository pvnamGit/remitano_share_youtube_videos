Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: ''
  post '/signup', to: 'user#create'
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'

  post '/share', to: 'video_share#create'
  get '/videos', to: 'video_share#index'
end
