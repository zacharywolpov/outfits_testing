Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  root 'users#show'
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  delete 'delete_closet', to: 'users#delete_closet'
  delete 'delete_outfits_history', to: 'users#delete_outfits_history'
  resources :users
  resources :sessions
  
  get '/inputs', to: 'inputs#index'
  get 'user_input_page/:id', to: 'inputs#index', as: 'user_input'
  post 'send_message', to: 'inputs#send_message'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
