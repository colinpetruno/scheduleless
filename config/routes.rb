require "resque_web"

Rails.application.routes.draw do
  root to: "marketing/welcome#index"

  resources :approvals, only: [:index]

  namespace :blog do
    root to: "welcome#index"
    resources :categories, only: [:show]

    namespace :admin, path: "management" do
      root to: "welcome#show"
      resources :blog_posts, only: [:create, :edit, :index, :new, :update]
    end

    resources :posts, only: [:show]
  end

  namespace :business, path: "company" do
    resources :users,
      only: [:create, :destroy, :edit, :index, :new, :show, :update],
      path: "employees"

    scope module: :employees, as: :employees do
      resources :users, path: "employees", only: [] do
        resource :account, only: [:show]
        resource :positions, only: [:show]
        resource :profile, only: [:show]
        resource :wages, only: [:show]
      end
    end
  end

  resource :dashboard, only: [:show]

  devise_for :login_users, path: "employees", controllers: {
    invitations: "login_users/invitations"
  }

  resources :employee_positions, only: [:destroy]

  get "getting_started", to: "marketing/welcome#getting_started", as: :getting_started
  get "how_it_works", to: "marketing/welcome#how_it_works", as: :how_it_works

  resources :locations, only: [:create, :edit, :index, :new, :show, :update] do
    resources :available_employees, only: [:index]
    resource :calendar, only: [:show]
    resource :join, only: [:create, :show]
    resource :print, only: [:show]

    scope module: :locations, as: :locations do
      resources :in_progress_shifts,
        only: [:create, :destroy, :edit, :new, :update],
        path: "pending_shifts"
      resources :shifts, only: [:create, :destroy, :edit, :new, :update]
      resources :schedule_rules, only: [:create, :destroy, :edit, :index, :update]
    end

    resources :trades, only: [:index]
    resources :user_locations, only: [:create]

    scope module: :locations, as: :locations do
      resources :users, only: [:create, :destroy, :edit, :update, :index, :new], path: "employees"
      resources :scheduling_hours, only: [:create, :edit, :destroy, :index, :new, :update], path: "hours"
    end
  end

  namespace :admin, path: "management" do
    root to: "welcome#index"

    resources :companies, only: [:destroy, :edit, :index, :update]
    resources :features, only: [:create, :edit, :index, :new, :update]
    resources :impersonations, only: [:new, :create]
    resources :plans, only: [:create, :edit, :index, :new, :update]
  end

  namespace :mobile_api do
    resources :firebase_tokens, only: [:create]
    resources :features, only: [:index]
    resource :featured_shift, only: [:show]
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

    resources :time_off_requests, only: [:index, :create]

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
    resource :company, only: [:edit, :update]
    resource :company_preferences, only: [:create, :new]
    resources :leads, only: [:new, :create], path: "contact"
    resources :locations, only: [:create, :edit, :index, :new, :update] do
      resource :scheduling_hours,
        only: [:show, :update],
        path: "hours"
      resources :users, path: :employees, only: [:create, :destroy, :index, :new]
    end
    resources :positions, only: [:create, :destroy, :new]
    resources :registrations, only: [:create, :new]
    resource :schedule_settings, only: [:edit, :show, :update]
  end

  get "pricing", to: "marketing/welcome#pricing", as: :pricing

  mount ResqueWeb::Engine, at: "/queues", anchor: false, constraints: lambda { |req|
    return true if Rails.env.development?

    # login user here LoginUser
    req.env['warden'].authenticated? and req.env['warden'].user.user.scheduleless_admin?
  }

  namespace :remote, defaults: { format: :js } do
    scope module: :employees, as: :employees do
      resources :users, path: "employees", only: [] do
        resource :positions, only: [:update]
        resource :profile, only: [:update]
        resource :wages, only: [:update]
      end
    end

    resources :in_progress_shifts, only: [] do
      scope module: :in_progress_shifts, as: :in_progress_shifts do
        resource :delete_confirmation, only: [:create, :new], path: "delete"
      end
    end

    resources :locations, only: [] do
      # TODO: ensure routes used in new_calendar/calendar are in the right
      # namespace
      resources :in_progress_shifts, only: [:create, :edit, :new, :update]
      resources :postings, only: [:create, :new]
    end

    namespace :calendar, only: [] do
      resources :locations, only: [] do
        resource :calendar_sidebar, only: [:show]
        resources :favorite_shifts, only: [:create, :new]
        resources :repeating_shifts, only: [:create, :edit, :new, :update]
        resources :wages, only: [:index]
      end

      resources :shifts, only: [] do
        resource :shift_detail, only: [:show], path: "details"
      end
    end

    namespace :dashboard do
      resources :shifts, only: [] do
        resource :check_in, only: [:create]
        resource :check_out, only: [:create]
      end

      resources :time_off_requests, only: [] do
        resources :time_off_approvals, only: [:create]
      end

      scope module: :offers, as: :offers do
        resources :offers, only: [] do
          resource :approval, only: [:create], path: "approve"
          resource :denial, only: [:create], path: "deny"
        end
      end
    end
  end

  namespace :reporting do
    resources :locations, only: [:index] do
      resource :statistics, only: [:show], path: "stats"
      resource :time_sheet, only: [:show]
    end
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

  resources :email_captures, only: [:create], path: "sign_up"

  resources :streams, only: [:show], defaults: { format: :ics }

  resources :time_off_requests, only: [:create, :index, :new] do
  end

  namespace :time_off_requests do
    resources :approvals, only: [:edit, :index]
  end

  scope module: :time_off_requests, as: :time_off_requests do
    resources :time_off_requests, only: [] do
      resources :approvals, only: [:create]
      resource :cancellations, only: [:update]
    end
  end

  resources :trades, only: [:index] do
    resource :trade_accept, only: [:create], path: "accept"
    resources :offers, only: [:create, :index, :new]
  end

  resource :unsubscribe, only: [:show, :update]

  resource :user, only: [:edit, :update]
end
