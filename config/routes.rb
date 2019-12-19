Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users

  get 'recipes/:id/next_step/:step', to: 'recipes#next_step'
  get 'recipes/:id/previous_step/:step', to: 'recipes#previous_step'

  resources :recipes, only: [:index, :show]
  resources :user_preferences, only: [:index, :update, :create]
  resources :user_categories, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
