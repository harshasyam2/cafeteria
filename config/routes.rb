Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "home#index"
  resources :menus
  resources :menuitems
  resources :customers
  resources :orders
  resources :orderitems
  get "/listorders", to: "orders#listorders", as: :list_orders
  get "/showlist", to: "orders#listshow", as: :show_list_orders
  get "/myorders", to: "orders#myorders", as: :my_orders
  post "/uniquecustomers", to: "customers#uniquecustomer", as: :unique_customer
  get "/create", to: "orderitems#create", as: :create_orderitem
  get "/signin", to: "sessions#new", as: :new_sessions
  post "/signin", to: "sessions#create", as: :sessions
  delete "/signout", to: "sessions#destroy", as: :destroy_session
end
