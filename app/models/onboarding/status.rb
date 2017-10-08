module Onboarding
  class Status
    # onboarding.companies/edit 0
    # onboarding/contact/new 1
    # onboarding/locations/new 2
    # onboarding/locations/44/hours 3
    # onboarding/positions/new 4
    # onboarding/locations/44/employees 5
    # onboarding/schedule_settings/edit 6
    # onboarding/schedule_settings 7 # last step / completed

    def self.for(company)
      new(company: company)
    end

    def initialize(company:)
      @company = company
    end

    def not_finished?
      company.onboarding_step != 7
    end

    def current_step
      case company.onboarding_step
      when 0
        routes.edit_onboarding_company_path
      when 1
        routes.new_onboarding_lead_path
      when 2
        if company.locations.present?
          routes.edit_onboarding_location_path(company.locations.first)
        else
          routes.new_onboarding_location_path
        end
      when 3
        routes.onboarding_location_scheduling_hours_path(company.locations.first)
      when 4
        routes.new_onboarding_position_path
      when 5
        routes.onboarding_location_users_path(company.locations.first)
      when 6
        routes.edit_onboarding_schedule_settings_path
      else
        routes.dashboard_path
      end
    end

    def move_to_next_step!(step)
      if step > company.onboarding_step
        company.update(onboarding_step: step)
      end
    end

    private

    attr_reader :company

    def routes
      Rails.application.routes.url_helpers
    end
  end
end
