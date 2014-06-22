Rails.application.routes.draw do
  resources :reports

  resources :accounts do
    get :update_billing, on: :member
  end

  root :to => "visitors#index"
  devise_for :users
  resources :users
end
