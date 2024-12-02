Rails.application.routes.draw do
  root 'inputs#index'
  
  get '/inputs', to: 'inputs#index'
  post 'send_message', to: 'inputs#send_message'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
