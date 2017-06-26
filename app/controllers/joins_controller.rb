class JoinsController < ApplicationController
  layout "onboarding"

  def create
    @location = Location.find_by!(hash_key: params[:location_id])
    @join = Join.new(join_params)

    if @join.process
      sign_in(@join.user)
      redirect_to default_calendar_path_for(@join.user)
    else
      render :show
    end
  end

  def show
    @location = Location.find_by(hash_key: params[:location_id])
    @join = Join.new
  end

  private

  def join_params
    params.
      require(:join).
      permit(
        :email,
        :first_name,
        :last_name,
        :mobile_phone,
        :password,
        :password_confirmation
      ).merge(
        location_id: @location.id
      )
  end
end
