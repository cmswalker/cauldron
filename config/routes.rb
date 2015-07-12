Rails.application.routes.draw do
  resources :ingredients
  resources :charts
  resources :users

  root to: "welcome#index"

  post "/sessions", to: "sessions#create", as: "user_login"

  get "/sessions", to: "sessions#destroy", as: "user_logout"

  post "/charts/:id/ingredients", to: "ingredients#create", as: "chart_ingredient_create"



  #                 Prefix Verb   URI Pattern                       Controller#Action
  #             ingredients GET    /ingredients(.:format)            ingredients#index
  #                         POST   /ingredients(.:format)            ingredients#create
  #          new_ingredient GET    /ingredients/new(.:format)        ingredients#new
  #         edit_ingredient GET    /ingredients/:id/edit(.:format)   ingredients#edit
  #              ingredient GET    /ingredients/:id(.:format)        ingredients#show
  #                         PATCH  /ingredients/:id(.:format)        ingredients#update
  #                         PUT    /ingredients/:id(.:format)        ingredients#update
  #                         DELETE /ingredients/:id(.:format)        ingredients#destroy
  #                  charts GET    /charts(.:format)                 charts#index
  #                         POST   /charts(.:format)                 charts#create
  #               new_chart GET    /charts/new(.:format)             charts#new
  #              edit_chart GET    /charts/:id/edit(.:format)        charts#edit
  #                   chart GET    /charts/:id(.:format)             charts#show
  #                         PATCH  /charts/:id(.:format)             charts#update
  #                         PUT    /charts/:id(.:format)             charts#update
  #                         DELETE /charts/:id(.:format)             charts#destroy
  #                   users GET    /users(.:format)                  users#index
  #                         POST   /users(.:format)                  users#create
  #                new_user GET    /users/new(.:format)              users#new
  #               edit_user GET    /users/:id/edit(.:format)         users#edit
  #                    user GET    /users/:id(.:format)              users#show
  #                         PATCH  /users/:id(.:format)              users#update
  #                         PUT    /users/:id(.:format)              users#update
  #                         DELETE /users/:id(.:format)              users#destroy
  #                    root GET    /                                 welcome#index
  #              user_login POST   /sessions(.:format)               sessions#create
  #             user_logout GET    /sessions(.:format)               sessions#destroy
  # chart_ingredient_create POST   /charts/:id/ingredients(.:format) ingredients#create

  
end
