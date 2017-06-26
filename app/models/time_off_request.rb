class TimeOffRequest < ApplicationRecord
  belongs_to :user
  before_validation :set_dates

  validates :start_date, presence: true

  enum status: {
    pending: 0,
    denied: 1,
    approved: 2
  }

  attr_writer :start_date_string, :end_date_string

  def start_date_string
    if @start_date_string.present?
      @start_date_string
    else
      start_date.present? ? Date.parse(start_date.to_s).to_s(:datepicker) : nil
    end
  end

  def end_date_string
    if @end_date_string.present?
      @end_date_string
    else
      end_date.present? ? Date.parse(end_date.to_s).to_s(:datepicker) : nil
    end
  end

  private

  def set_dates
    if start_date_string.present?
      self.start_date = Date.parse(start_date_string).to_s(:integer)
    end

    if end_date_string.present?
      self.end_date = Date.parse(end_date_string).to_s(:integer)
    end

    if start_date_string.blank?
      errors.add(:start_date_string, "Must be present")
    end
  end
end
