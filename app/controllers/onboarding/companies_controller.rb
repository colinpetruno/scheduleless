module Onboarding
  class CompaniesController < BaseController
    layout "onboarding"

    def edit
      @company = current_company
      # TODO: This is ugly but is used to skirt validations
      @company.name = "" if @company.name == "My Company Name"

      authorize @company
    end

    def update
      @company = current_company

      authorize @company

      if @company.update(company_params)
        begin
          StripeCustomer.for(current_company).update
        rescue StandardError => error
          Bugsnag.notify(error)
        end

        Onboarding::Status.for(current_company).move_to_next_step!(2)
        redirect_to new_onboarding_location_path
      else
        render :edit
      end
    end

    private

    def company_params
      params.require(:company).permit(:name, :size)
    end
  end
end
