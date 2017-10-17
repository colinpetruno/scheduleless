module StatefulParams
  extend ActiveSupport::Concern

  def mode
    cookies[:mode] = params[:mode] || cookies[:mode] || "scheduling"
    cookies[:mode]
  end

  def view
    cookies[:view] = params[:view] || cookies[:view] ||  "weekly"
    cookies[:view]
  end
end
