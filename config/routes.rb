Rails.application.routes.draw do
  root 'welcome#index'

  resources :merchants
  resources :items, except: [:create, :new]
  resources :reviews, only: [:edit, :update, :destroy]
  resources :orders, only: [:new, :create, :show]

  scope :merchants do
    get    "/:merchant_id/items",     to: "items#index"
    get    "/:merchant_id/items/new", to: "items#new"
    post   "/:merchant_id/items",     to: "items#create"
  end

  scope :items do
    get  "/:item_id/reviews/new", to: "reviews#new"
    post "/:item_id/reviews",     to: "reviews#create"
  end

  scope :cart do
    post   "/:item_id", to: "cart#add_item"
    get    "/",          to: "cart#show"
    delete "/",          to: "cart#empty"
    delete "/:item_id", to: "cart#remove_item"
    patch '/:item_id/increase', to: 'cart#increase_quantity'
    patch '/:item_id/decrease', to: 'cart#decrease_quantity'
  end

  scope :register do
    get  '/', to: 'users#new'
    post '/',    to: 'users#create'
  end

  scope :login do
    get '/', to: 'sessions#new'
    post '/', to: 'sessions#create'
  end

  scope :logout do
    get '/', to: 'sessions#destroy'
    delete '/', to: 'sessions#destroy'
  end

  scope :profile do
    get  '/',  to: 'users#show'
    get '/edit', to: 'users#edit'
    patch '/', to: 'users#update'
    get '/edit_password', to: 'users#edit_password'
    patch '/update_password', to: 'users#update_password'
    get '/orders', to: 'user_orders#index'
    get '/orders/:order_id', to: 'user_orders#show'
    patch '/orders/:order_id', to: 'user_orders#cancel_order'
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/dashboard', to: 'dashboard#index'
    patch '/orders/:order_id', to: 'dashboard#fulfill_item'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/users', to: 'users#index'
    get '/dashboard', to: 'dashboard#index'
    patch '/orders/:order_id', to: 'dashboard#ship_order'
  end
end
