require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "marketing/welcome#index"

  namespace :business, path: "company" do
    resources :users,
      only: [:create, :destroy, :edit, :index, :new, :show, :update],
      path: "employees"
  end

  resource :calendar, only: [:show]

  resources :employee_positions, only: [:destroy]

  resources :locations, only: [:create, :edit, :index, :new, :show, :update] do
    resources :available_employees, only: [:index]
    resource :calendar, only: [:show]
    resource :daily_schedule, only: [:show]
    resources :trades, only: [:index]
    resources :user_locations, only: [:create]

    scope module: :locations, as: :locations do
      resources :users, only: [:create, :destroy, :index, :new], path: "employees"
    end
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

  resource :my_trades, only: [:show]

  use_doorkeeper # makes /oauth routes

  resources :offers, only: [] do
    resource :offer_accept, only: [:create], path: "accept"
    resource :offer_decline, only: [:create], path: "decline"
  end

  namespace :onboarding do
    resource :company_preferences, only: [:create, :new]
    resources :locations, only: [:create, :index, :new] do
      resources :users, path: :employees, only: [:create, :index, :new]
    end
    resources :positions, only: [:create, :destroy, :new]
    resources :registrations, only: [:create, :new]
    resource :schedule, only: [:create, :new]
    resources :user, only: [:destroy]
  end

  # TODO: AUTH THIS
  mount Sidekiq::Web, at: "/queues"

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
    resources :credit_cards, only: [:create, :destroy, :edit, :index, :new, :update]

    resources :popular_times, only: [:index]

    resources :popular_date_range_times, only: [:create, :destroy, :edit, :new, :update]
    resources :popular_holiday_times, only: [:create, :destroy, :edit, :new, :update]
    resources :popular_time_range_times, only: [:create, :destroy, :edit, :new, :update]
    resources :popular_weekday_times, only: [:create, :destroy, :edit, :new, :update]

    resources :positions, only: [:create, :destroy, :edit, :index, :new, :update] do
      resource :confirm_delete, only: [:show, :destroy]
    end
    resources :schedule_rules, only: [:create, :destroy, :edit, :index, :update]
    resource :subscription, only: [:edit, :update]
  end

  resources :shifts, only: [:index] do
    resource :cancellation, only: [:create], path: "cancel"
    resource :check_in, only: [:create]
    resource :check_out, only: [:create]
    resources :trades, only: [:create, :new]
  end

  resources :trades, only: [:index] do
    resource :trade_accept, only: [:create], path: "accept"
    resources :offers, only: [:create, :index, :new]
  end

  resource :user, only: [:edit, :update]

  devise_for :users, controllers: { invitations: "users/invitations" }
end
