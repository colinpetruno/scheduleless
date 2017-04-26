class Shift < ApplicationRecord
  belongs_to :user_location
  belongs_to :company

  has_many :check_ins
  has_one :location, through: :user_location

  accepts_nested_attributes_for :company, :user_location

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
end
