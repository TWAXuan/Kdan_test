Rails.application.routes.draw do
  root to: 'admins#index'

  get :store_scan, to: "features#store_scan"
  get :books_scan, to: "features#books_scan"

  resources :book, only: [:index, :edit, :update]
  resources :store, only: [:index, :edit, :update]
  resources :user, only: [:index, :edit, :update]

  get :user_purchase_login, to: "user_purchase#login"
  resources :user_purchase, only: [:index, :create]
  post :user_purchase_check, to: "user_purchase#check"
end
