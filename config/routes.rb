Rails.application.routes.draw do
  resources :users
  resources :beers
  resources :breweries

  root 'breweries#index'
  get 'signup', to: 'users#new'
  get 'kaikki_bisset', to: 'beers#index'

  resources :ratings, only: [:index, :new, :create, :destroy]
  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  #post 'ratings', to: 'ratings#create'

  resource :session, only: [:new, :create, :destroy]
end
