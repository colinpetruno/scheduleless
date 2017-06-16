module Onboarding
  class LeadsController < AuthenticatedController
    layout "onboarding"

    def create
      authorize :lead, :create?

      if current_user.update(lead_params)
        begin
          SupportMailer.lead(current_user.leads.last).deliver
        rescue StandardError => error
          Bugsnag.notify(error)
          Bugsnag.notify("New User - Support Email Failed To Send")
        end

        render :create
      else
        @lead = current_user.leads.last
        render :new
      end
    end

    def new
      @lead = current_user.leads.build

      authorize @lead
    end

    private

    def lead_params
      params.
        require(:user).
        permit(
          :email,
          :family_name,
          :given_name,
          :mobile_phone,
          leads_attributes: [:note, :preferred_contact]
        )
    end
  end
end
