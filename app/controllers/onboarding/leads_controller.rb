module Onboarding
  class LeadsController < AuthenticatedController
    layout "onboarding"

    def create
      authorize :lead, :create?

      # TODO: Find a better way, lead is validating before parent attributes
      # are assigned so we need to update just the user first then the user
      # with the lead attributes. However this is ugly. Very Ugly.
      if current_user.update(user_params) && current_user.update(lead_params)
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

    def user_params
      params.
        require(:user).
        permit(:email, :family_name, :given_name, :mobile_phone)
    end

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
