Rails.application.routes.draw do
  devise_for :users

  resources :recipes, only: [:index, :show]
  resources :user_preferences, only: [:index, :update]
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
