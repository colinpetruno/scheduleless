class NotificationsMailerPreview < ActionMailer::Preview
  def employee_joined_location
    u = User.first
    u2 = User.second
    l = Location.first

    NotificationsMailer.employee_joined_location(u, u2, l)
  end

  def schedule_approved
    u = User.first
    sp = SchedulingPeriod.last

    NotificationsMailer.schedule_approved(u, sp)
  end

  def schedule_published
    u = User.first
    sp = SchedulingPeriod.last

    NotificationsMailer.schedule_published(u, sp)
  end

  def offer_denied
    s = Shift.last
    s2 = Shift.last(2).first
    u = s.user
    u2 = s2.user

    t = Trade.last
    o = Offer.new(trade: t, user: u2, offered_shift: s2, note: "heres a shift for you")
    t.offers << o

    NotificationsMailer.offer_denied(u, t, o)
  end

  def trade_completed
    s = Shift.last
    s2 = Shift.last(2).first
    u = s.user
    u2 = s2.user

    t = Trade.last
    o = Offer.new(trade: t, user: u2, offered_shift: s2, note: "heres a shift for you")
    t.offers << o

    NotificationsMailer.trade_completed(u, t, o)
  end

  def trade_waiting_approval
    s = Shift.last
    s2 = Shift.last(2).first
    u = s.user
    u2 = s2.user

    t = Trade.last
    o = Offer.new(trade: t, user: u2, offered_shift: s2, note: "heres a shift for you")
    t.offers << o

    NotificationsMailer.trade_awaiting_approval(u, t, o)
  end

  def new_trade_approval
    s = Shift.last
    s2 = Shift.last(2).first
    u = s.user
    u2 = s2.user

    t = Trade.last
    o = Offer.new(trade: t, user: u2, offered_shift: s2, note: "heres a shift for you")
    t.offers << o

    NotificationsMailer.new_trade_approval(u, t, o)
  end

  def new_offer
    s = Shift.last
    s2 = Shift.last(2).first
    u = s.user
    u2 = s2.user

    t = Trade.last
    o = Offer.new(trade: t, user: u2, offered_shift: s2, note: "heres a shift for you")

    NotificationsMailer.new_offer(u, o)
  end

  def offer_declined
    s = Shift.last
    s2 = Shift.last(2).first
    u = s.user
    u2 = s2.user

    t = Trade.last
    o = Offer.new(trade: t, user: u2, offered_shift: s2, note: "heres a shift for you")

    NotificationsMailer.offer_declined(u, o)
  end

  def new_time_off_approval
    u = User.first
    to = TimeOffRequest.last

    NotificationsMailer.new_time_off_approval(u, to)
  end

  def time_off_request_denied
    u = User.first
    to = TimeOffRequest.last

    NotificationsMailer.time_off_request_denied(u, to)
  end

  def time_off_request_approved
    u = User.first
    to = TimeOffRequest.last

    NotificationsMailer.time_off_request_approved(u, to)
  end

  def new_trade
    s = Shift.last
    u = s.user

    t = Trade.new(shift: s, location: s.location, user: u)

    NotificationsMailer.new_trade(u, t)
  end
end
