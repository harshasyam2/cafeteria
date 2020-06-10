Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "home#index", as: :root
  resources :menus
  resources :menuitems
  resources :customers
  resources :orders
  resources :orderitems
  resources :contacts
  resources :randomnumbers
  resources :payments
  get "/aboutus", to: "home#aboutus", as: :about_us
  get "/privacypolicy", to: "home#privacypolicy", as: :privacy_policy
  get "/viewprofile", to: "customers#viewprofile", as: :view_profile_customer
  post "/profile", to: "customers#profile", as: :profile_customer
  get "/forgotpassword", to: "customers#forgotpassword", as: :forgot_password
  get "/checkdetails", to: "customers#checkdetails", as: :check_details
  get "/updatepassword", to: "customers#updatepassword", as: :update_password
  get "/invoice", to: "orders#invoice", as: :invoice
  get "/listorders", to: "orders#listorders", as: :list_orders
  get "/showlist", to: "orders#listshow", as: :show_list_orders
  get "/myorders", to: "orders#myorders", as: :my_orders
  get "/deliver", to: "orders#deliver", as: :deliver_order
  get "/ownermenus", to: "menus#ownermenus", as: :owner_menus
  get "/managemenus", to: "menus#managemenus", as: :manage_menus
  post "/uniquecustomers", to: "customers#uniquecustomer", as: :unique_customer
  post "/menuitem/unique", to: "menuitems#uniquemenuitem", as: :unique_menuitem
  get "/deleteorder", to: "orders#deleteorder", as: :delete_order
  get "/deleteorderitems", to: "orderitems#destroyorderitem", as: :delete_orderitem
  get "/randomnumbers", to: "randomnumbers#index", as: :randomnumbers_path
  get "/createmenuitem", to: "menuitems#createmenuitem", as: :create_menuitem
  get "/destroymenuitem", to: "menuitems#destroymenuitem", as: :destroy_menuitem
  get "/menuitem/unique", to: "menus#index"
  get "/feedback_list", to: "contacts#feedback", as: :feedback_contact
  get "/create", to: "orderitems#create", as: :create_orderitem
  get "/signin", to: "sessions#new", as: :new_sessions
  post "/signin", to: "sessions#create", as: :sessions
  delete "/signout", to: "sessions#destroy", as: :destroy_session
end
