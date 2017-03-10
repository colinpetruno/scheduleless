Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "marketing/welcome#index"

  resource :calendar
  resources :locations, only: [:index, :show, :new, :create, :edit]

  namespace :onboarding do
    resource :company_preferences, only: [:new, :create]
    resources :locations, only: [:new, :create] do
      resources :users, path: :employees, only: [:new, :create]
    end
    resources :registrations, only: [:new, :create]
    resource :schedule, only: [:new, :create]
  end
end
