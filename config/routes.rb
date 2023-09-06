Rails.application.routes.draw do
  resources :foods
  resources :shopping_lists, only: [:index]
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "foods#index"
  resources :recipes, only: [:index, :show, :new, :create, :destroy] do
    member do
      patch :toggle_public
      get :shopping_list
    end

    resources :recipe_foods, only: [:new, :create, :edit, :update,  :destroy]
  end

  get 'users', to: 'users#index'

  resources :public_recipes

end