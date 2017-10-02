class Shift < ApplicationRecord
  belongs_to :company
  belongs_to :location
  belongs_to :position
  belongs_to :user

  has_many :check_ins
  has_one :trade

  accepts_nested_attributes_for :company

  before_save :set_date

  enum state: {
    active: 0,
    traded: 1,
    taken: 2,
    cancelled: 3
  }

  attr_writer :day, :month, :year

  def self.default_scope
    where(deleted_at: nil)
  end

  def day
    if @day
      return @day.to_s
    end

    if !date.nil?
      Date.parse(date.to_s).day.to_s
    end
  end

  def edited?
    # maintain same interface as in_progress_shift
    false
  end

  def month
    if @month
      month_int =  @month.to_s
    end

    if !date.nil?
      month_int = Date.parse(date.to_s).month.to_s
    end

    if !month_int.nil?
      month_int.rjust(2, "0")
    end
  end

  def repeating?
    repeating_shift_id.present?
  end

  def year
    if @year
      return @year.to_s
    end

    if !date.nil?
      Date.parse(date.to_s).year.to_s
    end
  end

  def belongs_to?(possible_user)
    possible_user.id == user.id
  end

  def can_check_in?
    # TODO: Update this to allow checking up to 10-15minutes before shift start
    !checked_in?
  end

  def checked_in?
    check_ins.present? && check_ins.find_by(check_out_date_time: nil).present?
  end

  def current_check_in
    check_ins.find_by(check_out_date_time: nil).present?
  end

  def length_in_minutes
    # TODO: remove for ShiftDateTime class
    DateAndTime::ShiftDateTime.for(self).length_in_minutes
  end

  def selection_label
    "#{DateAndTime::Parser.new(date: date).month_and_day}, #{MinutesToTime.for(minute_start)} - #{MinutesToTime.for(minute_end)}"
  end

  def time_range
    "#{MinutesToTime.for(minute_start)}-#{MinutesToTime.for(minute_end)}"
  end

  private

  def set_date
    if day.present? && month.present? && year.present?
      self.date = "#{year.rjust(4, "0")}#{month.rjust(2, "0")}#{day.rjust(2, "0")}"
    end
  end
end
