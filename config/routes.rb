Rails.application.routes.draw do
  devise_for :users

  resources :recipes, only: [:index, :show]
  get 'recipes/:id/next_step/:step', to: 'recipes#next_step'
  get 'recipes/:id/previous_step/:step', to: 'recipes#previous_step'
  resources :user_preferences, only: [:index, :update, :create]
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
