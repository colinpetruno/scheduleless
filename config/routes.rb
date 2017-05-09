Rails.application.routes.draw do
  root to: "marketing/welcome#index"

  namespace :business, path: "company" do
    resources :users, only: [:edit, :index, :show, :update], path: "employees"
  end

  resources :locations, only: [:create, :edit, :index, :new, :show, :update] do
    resources :available_employees, only: [:index]
    resource :calendar, only: [:show]
    resource :daily_schedule, only: [:show]
    resources :trades, only: [:index]
    resources :user_locations, only: [:create]
  end

  namespace :mobile_api do
    resource :future_shifts, only: [:show]
    resources :locations, only: [:index]

    resource :my_trades, only: [:show]

    resources :offers, only: [] do
      resource :offer_accept, only: [:create], path: "accept"
      resource :offer_decline, only: [:create], path: "decline"
    end

    resources :shifts, only: [] do
      resource :cancellation, only: [:create], path: "cancel"
      resource :check_in, only: [:create]
      resource :check_out, only: [:create]

      resources :trades, only: [:create]
    end

    resources :trades, only: [:index] do
      resources :offers, only: [:create, :index]
    end
  end

  use_doorkeeper # makes /oauth routes

  resources :offers, only: [] do
    resource :offer_accept, only: [:create], path: "accept"
    resource :offer_decline, only: [:create], path: "decline"
  end

  namespace :onboarding do
    resource :company_preferences, only: [:create, :new]
    resources :locations, only: [:create, :new] do
      resources :users, path: :employees, only: [:create, :new]
    end
    resources :registrations, only: [:create, :new]
    resource :schedule, only: [:create, :new]
  end

  namespace :scheduler do
    resources :locations, only: [] do
      resource :schedule_preview, only: [:create]
    end

    resource :schedule_preview, only: [:show]

    resource :schedule, only: [:create, :show]
  end

  resource :schedules_management, only: [:create, :show]
  resource :search, only: [:show]

  resource :settings, only: [:show]

  namespace :settings do
    resource :company_preference, only: [:edit, :update]
    resources :credit_cards, only: [:create, :edit, :index, :new, :update]

    resources :popular_times, only: [:index, :new]

    resources :popular_date_range_times, only: [:create]
    resources :popular_holiday_times, only: [:create]
    resources :popular_time_range_times, only: [:create]
    resources :popular_weekday_times, only: [:create]

    resources :positions, only: [:create, :index, :new,]
    resources :schedule_rules, only: [:create, :index]
    resource :subscription, only: [:edit, :update]
  end

  resources :shifts, only: [:index] do
    resource :cancellation, only: [:create], path: "cancel"
    resource :check_in, only: [:create]
    resource :check_out, only: [:create]
    resources :trades, only: [:create, :new]
  end

  resources :trades, only: [] do
    resource :trade_accept, only: [:create], path: "accept"
    resources :offers, only: [:create, :index, :new]
  end

  resource :user, only: [:edit, :update]

  devise_for :users
end
