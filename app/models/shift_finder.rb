class ShiftFinder
  def self.for(object)
    new(object: object)
  end

  def initialize(object:)
    @object = object
    self.scope = all
  end

  def checked_in
    self.scope = scope.
      joins(:check_ins).
      where(check_ins: { check_out_date_time: nil }).
      first

    self
  end

  def current
    # TODO: this needs fixed for timezones
    self.scope = scope.
      where(date: current_day, minute_end: ((current_minute - 15)..1440))
    self
  end

  def includes(*args)
    self.scope = scope.includes(*args)
    self
  end

  def find
    scope
  end

  def worked_by(user)
    self.scope = scope.where(user_id: user.id)
    self
  end

  def next
    self.scope = future.find.first
    self
  end

  def on(date=Date.today)
    self.scope = scope.where(date: date.strftime('%Y%m%d').to_i)
    self
  end

  def future
    # these shifts drop off 15 minutes after they over
    # TODO fix for timezones
    self.scope = scope.
      where(date: (current_day+1..Float::INFINITY)).
      or(all.
         where(date: current_day, minute_end: ((current_minute - 15)..1440)))
    self
  end

  def find_by(options)
    scope.find_by(options)
  end

  private

  attr_accessor :scope
  attr_reader :object

  def all
    object.
      shifts.
      active.
      order(:date, :minute_start)
  end

  def current_day
    Date.today.to_s(:number).to_i
  end

  def current_minute
    (Time.now.hour * 60) + Time.now.min
  end
end
