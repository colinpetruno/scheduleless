Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "marketing/welcome#index"
  resource :calendar
  resource :schedules_management


  namespace :business, path: "company" do
    resources :users, only: [:index, :edit, :update], path: "employees"
  end

  resources :locations, only: [:index, :show, :new, :create, :edit]

  namespace :onboarding do
    resource :company_preferences, only: [:create, :new]
    resources :locations, only: [:create, :new] do
      resources :users, path: :employees, only: [:create, :new]
    end
    resources :registrations, only: [:create, :new]
    resource :schedule, only: [:create, :new]
  end

  resources :settings, only: [:index]

  namespace :settings do
    resource :company_preferences, only: [:edit, :update]
    resources :positions, only: [:create, :index, :new,]
    resources :schedule_rules, only: [:create, :index]
  end

  resource :user, only: [:edit, :update]

  devise_for :users
end
