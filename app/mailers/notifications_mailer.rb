class NotificationsMailer < ApplicationMailer
  default from: "support@scheduleless.com",
          reply_to: "support@scheduleless.com"

  def employee_joined_location(user, new_employee, location)
    @user = user
    @new_employee = new_employee
    @location = location

    mail(to: user.email)
  end

  def new_offer(user, offer)
    @user = user
    @offer = offer

    mail(to: user.email)
  end

  def offer_declined(user, offer)
    @user = user
    @offer = offer

    mail(to: user.email)
  end

  def new_trade(user, trade)
    @user = user
    @trade = trade

    mail(to: user.email)
  end

  def schedule_approved(user, scheduling_period)
    @location = scheduling_period.location
    @scheduling_period = scheduling_period
    @user = user

    mail(to: user.email)
  end

  def schedule_published(user, scheduling_period)
    @location = scheduling_period.location
    @scheduling_period = scheduling_period
    @user = user

    mail(to: user.email)
  end

  def new_time_off_approval(user, time_off_request)
    @user = user
    @presenter = NotificationsMailers::NewTimeOffApprovalPresenter.
      new(time_off_request)

    mail(to: user.email)
  end

  def time_off_request_denied(user, time_off_request)
    @time_off_request = time_off_request
    @user = user

    mail(to: user.email)
  end

  def time_off_request_approved(user, time_off_request)
    @time_off_request = time_off_request
    @user = user

    mail(to: user.email)
  end
end
