Rails.application.routes.draw do
  devise_for :users

  root to: 'landing_pages#home'

  namespace :admin do
    resources :countries
    resources :transactions, only: [:index, :show] do
      get :approve, on: :member
      get :reject, on: :member
    end
  end
end
