class Shift < ApplicationRecord
  belongs_to :company
  belongs_to :location
  belongs_to :user

  has_many :check_ins
  has_one :trade

  accepts_nested_attributes_for :company

  enum state: {
    active: 0,
    traded: 1,
    taken: 2,
    cancelled: 3
  }

  attr_accessor :year
  attr_accessor :month
  attr_accessor :date

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
    # TODO: Harden against overnight shifts
    minute_end - minute_start
  end

  def selection_label
    "#{DateParser.new(date: date).month_and_day}, #{MinutesToTime.for(minute_start)} - #{MinutesToTime.for(minute_end)}"
  end

  def time_range
    "#{MinutesToTime.for(minute_start)}-#{MinutesToTime.for(minute_end)}"
  end
end
