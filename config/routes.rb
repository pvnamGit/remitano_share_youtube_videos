Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: ''
  root 'video_share#index'

  resources :user, only: [:new, :create]
  resources :session
  get '/signup', to: 'user#new'
  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'

  post '/share', to: 'video_share#create'
  get '/share', to: 'video_share#new'
  get '/videos', to: 'video_share#index'
  get '/my_videos', to: 'video_share#my_videos', as: 'my_videos'
  delete '/my_videos/:id', to: 'video_share#destroy', as: 'delete_video'
end
