require 'api_constraints'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root to: 'landing_pages#home'

  namespace :admin do
    resources :countries
    resources :transactions, only: [:index, :show] do
      get :approve, on: :member
      get :reject, on: :member
    end
  end

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
      }, skip: [:sessions, :password]
      resources :countries, only: :index
      resources :balances, only: :index
    end
  end
end
