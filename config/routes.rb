Rails.application.routes.draw do
  resources :reports

  resources :accounts

  root :to => "visitors#index"
  devise_for :users
  resources :users
end
