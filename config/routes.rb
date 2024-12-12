Rails.application.routes.draw do
  root 'users#index'
  resources :users
  
  get '/inputs', to: 'inputs#index'
  get 'user_input_page/:id', to: 'inputs#index', as: 'user_input'
  post 'send_message', to: 'inputs#send_message'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
