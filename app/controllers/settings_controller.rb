class SettingsController < AuthenticatedController
  def show
    authorize :settings, :show?
  end
end
