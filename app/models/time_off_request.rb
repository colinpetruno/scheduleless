class TimeOffRequest < ApplicationRecord
  belongs_to :user
  before_validation :set_dates

  validates :start_date, presence: true
  validate :times_are_valid

  enum status: {
    pending: 0,
    denied: 1,
    approved: 2
  }

  attr_writer :start_date_string, :end_date_string

  def badge_type
    if pending?
      "info"
    elsif approved?
      "notice"
    else
      "warning"
    end
  end

  def approved?
    status == "approved"
  end

  def label
    start_array = [start_date_string, start_time_string].compact
    end_array = [end_date_string, end_time_string].compact

    # TODO: tidy up
    if start_date_string.present? && end_date_string.present?
      "#{start_array.join(' ')} to #{end_array.join(' ')}"
    elsif start_date_string.present? && end_date_string.blank? &&  end_time_string.present?
      "#{start_date_string} from #{start_time_string} to #{end_time_string}"
    else
      start_array.join(' ')
    end
  end

  def start_time_string
    if start_minutes.present?
      MinutesToTime.for(start_minutes)
    end
  end

  def end_time_string
    if end_minutes.present?
      MinutesToTime.for(end_minutes)
    end
  end

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

  def times_are_valid
    if @end_date_string.present? && @start_date_string.blank?
      errors.add(:end_date_string, "Must choose a start date")
    end

    if end_minutes.present? && start_minutes.blank?
      errors.add(:start_minutes, "Select a start time")
    end
  end

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
