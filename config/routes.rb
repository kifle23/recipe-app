Rails.application.routes.draw do
  resources :foods
  devise_for :users

  root "users#index"
end
