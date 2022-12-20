Rails.application.routes.draw do
  resources :memberships
  resources :beerclubs
  resources :users
  resources :beers
  resources :breweries

  root 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'signout', to: 'sessions#destroy'
  delete 'signout', to: 'sessions#destroy'

  resources :ratings, only: [:index, :new, :create, :destroy]
  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  #post 'ratings', to: 'ratings#create'

  resource :session, only: [:new, :create, :destroy]

  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'
end
