Rails.application.routes.draw do
  get 'static_pages/terms_of_service'
  get 'static_pages/privacy_policy'
  root "boards#index"
  resources :users, only: %i[new create]
  resources :boards

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get '/terms_of_service', to: 'static_pages#terms_of_service'
  get '/privacy_policy', to: 'static_pages#privacy_policy'
end
