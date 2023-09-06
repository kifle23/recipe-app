Rails.application.routes.draw do
  resources :foods
  resources :shopping_lists, only: [:index]
  devise_for :users

  root "users#index"
end
