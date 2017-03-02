Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "marketing/welcome#index"

  resource :calendar

  namespace :onboarding do
    resource :company_preferences, only: [:new, :create]
    resources :locations, only: [:new, :create] do
      resources :schedules, only: [:new, :create]
      resources :users, path: :employees, only: [:new, :create]
    end
    resources :registrations, only: [:new, :create]
  end
end
