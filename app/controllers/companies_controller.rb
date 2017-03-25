class CompaniesController < AuthenticatedController
  def update
    current_company.update(company_params)
    redirect_to calendar_path
  end

  private

  def company_params
    params.
      require(:company).
      permit(shifts_attributes: [:company_id,
                                 :user_location_id,
                                 :minute_start,
                                 :minute_end,
                                 :date])
  end
end