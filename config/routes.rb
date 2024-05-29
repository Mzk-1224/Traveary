Rails.application.routes.draw do
  root "boards#index"
  resources :users, only: %i[new create]
  resources :boards

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end