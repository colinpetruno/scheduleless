Rails.application.routes.draw do
  root to: "marketing/welcome#index"
  resource :calendar
  resource :schedules_management do

  end

  namespace :business, path: "company" do
    resources :users, only: [:edit, :index, :show, :update], path: "employees"
  end

  resources :locations, only: [:create, :edit, :index, :new, :show]

  namespace :onboarding do
    resource :company_preferences, only: [:create, :new]
    resources :locations, only: [:create, :new] do
      resources :users, path: :employees, only: [:create, :new]
    end
    resources :registrations, only: [:create, :new]
    resource :schedule, only: [:create, :new]
  end

  namespace :scheduler do
    resource :schedule, only: [:create, :show]
    resource :schedule_preview, only: [:create, :show]
  end

  resource :search, only: [:show]

  resource :settings, only: [:show]

  namespace :settings do
    resource :company_preference, only: [:edit, :update]
    resources :positions, only: [:create, :index, :new,]
    resources :schedule_rules, only: [:create, :index]
  end

  resource :user, only: [:edit, :update]

  devise_for :users
end
