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
        delete_manage_positions
        delete_popular_times
        delete_preferences
        delete_preferred_hours
        delete_schedule_rules
        delete_scheduling_hours
        delete_shifts
        delete_subscriptions
        delete_trades
        delete_user_locations

        delete_favorite_shifts # implement
        delete_firebase_tokens
        delete_in_progress_shifts
        delete_offers
        delete_postings
        delete_repeating_shifts
        delete_time_off_requests

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

    def delete_time_off_requests
      TimeOffRequest.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_repeating_shifts
      RepeatingShift.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_postings
      Posting.
        joins(:location).
        where(locations: { company_id: company.id }).
        delete_all
    end

    def delete_offers
      Offer.where(company_id: company.id).delete_all
    end

    def delete_in_progress_shifts
      InProgressShift.where(company_id: company.id).delete_all
    end

    def delete_firebase_tokens
      FirebaseToken.
        joins(:user).
        where(users: { company_id: company.id }).
        delete_all
    end

    def delete_favorite_shifts
      FavoriteShift.
        joins(:location).
        where(locations: { company_id: company.id }).
        delete_all
    end

    def delete_manage_positions
      ManagePosition.
        where(position_id: company.positions.pluck(:id)).
        delete_all
    end

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

    def delete_scheduling_hours
      SchedulingHour.
        where(location_id: company.locations.pluck(:id)).
        delete_all
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
        where(resource_owner_id: users.pluck(:id)).
        delete_all
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
