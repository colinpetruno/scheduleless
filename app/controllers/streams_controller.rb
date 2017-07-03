class StreamsController < ApplicationController
  # WARNING NOT AUTHED

  def show
    user = User.find_by!(hash_key: params[:id])
    user_stream_calendar = UserStreamCalendar.for(user)

    render(
      plain: user_stream_calendar.publish,
      content_type: "text/calendar",
      status: :ok
    )
  end
end
