Rails.application.routes.draw do

  resources :accounts do
    get :update_billing, on: :member
  end

  resources :instances do
    get :load_from_aws, on: :collection
    get :start, on: :member
    get :stop, on: :member
  end

  resources :reports

  devise_for :users
  resources :users

  root :to => "visitors#index"

end
