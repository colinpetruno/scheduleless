module Onboarding
  class LeadsController < AuthenticatedController
    layout "onboarding"

    def create
      authorize :lead, :create?

      @lead = current_user.leads.build(lead_params)

      if @lead.save
        begin
          SupportMailer.lead(current_user.leads.last).deliver if Rails.env.production?
        rescue StandardError => error
          Bugsnag.notify(error)
          Bugsnag.notify("New User - Support Email Failed To Send")
        end

        render :create
      else
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
        require(:lead).
        permit(
          :mobile_phone,
          :note,
          :preferred_contact
        )
    end
  end
end
