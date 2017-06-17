module Admin
  class CompanyDestroyer
    def self.for(company)
      new(company: company)
    end

    def initialize(company:)
      @company = company
    end

    def destroy
      return false unless company.demo?

      ActiveRecord::Base.transaction do
        delete_check_ins
        delete_credit_cards
        delete_employee_positions
        delete_in_progress_shifts
        delete_leads
        delete_oauth_tokens
        delete_popular_times
        delete_preferences
        delete_preferred_hours
        delete_schedule_rules
        delete_schedule_settings
        delete_scheduling_hours
        delete_scheduling_periods
        delete_shifts
        delete_subscriptions
        delete_trades
        delete_user_locations
        delete_users

        delete_locations
        delete_positions

        company.destroy
      end

      true
    rescue StandardError => error
      Bugsnag.notify(error)
      false
    end

    private

    attr_reader :company

    def delete_users
      users.delete_all
    end

    def delete_user_locations
      UserLocation.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_trades
      Trade.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_subscriptions
      Subscription.where(company_id: company.id).delete_all
    end

    def delete_shifts
      Shift.where(company_id: company.id).delete_all
    end


    def delete_scheduling_periods
      SchedulingPeriod.
        where(company_id: company.id).
        delete_all
    end

    def delete_scheduling_hours
      SchedulingHour.
        where(location_id: company.locations.pluck(:id)).
        delete_all
    end

    def delete_schedule_settings
      ScheduleSetting.where(company_id: company.id).delete_all
    end

    def delete_schedule_rules
      ScheduleRule.
        where(ruleable_type: "Company", ruleable_id: company.id).
        delete_all

      ScheduleRule.
        where(ruleable_type: "Location",
              ruleable_id: company.locations.pluck(:id)).
        delete_all
    end

    def delete_preferred_hours
      PreferredHour.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_preferences
      Preference.
        where(preferable_type: "Company", preferable_id: company.id).
        delete_all

      Preference.
        where(preferable_type: "Location",
              preferable_id: company.locations.pluck(:id)).
        delete_all
    end

    def delete_positions
      Position.where(company_id: company.id).delete_all
    end

    def delete_offers
      Offer.where(company_id: company.id).delete_all
    end

    def delete_oauth_tokens
      Doorkeeper::AccessToken.
        where(resource_owner_id: users.pluck(:id))
    end

    def delete_check_ins
      CheckIn.
        joins(shift: [:user]).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_credit_cards
      company.credit_cards.delete_all
    end

    def delete_employee_positions
      EmployeePosition.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_firebase_tokens
      FirebaseToken.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_leads
      Lead.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_locations
      Location.where(company_id: company.id).delete_all
    end

    def delete_popular_times
      PopularTime.
        where(popular_type: "Company", popular_id: company.id).
        delete_all

      PopularTime.
        where(popular_type: "Location",
              popular_id: company.locations.pluck(:id)).
        delete_all
    end

    def delete_in_progress_shifts
      InProgressShift.where(company_id: company.id).delete_all
    end

    def users
      User.where(company_id: company.id)
    end
  end
end
