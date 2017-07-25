class SchedulingPeriod < ApplicationRecord
  attr_reader :date

  belongs_to :company
  belongs_to :location

  has_many :in_progress_shifts

  # before_validation :set_end_date

  validates :end_date, presence: true
  validates :start_date, presence: true

  enum status: {
    empty: 0,
    generated: 1,
    scheduleless_approved: 2, # TODO: this status is going to be deleted
    company_approved: 3, # TODO: this status is going to be deleted
    published: 4,
    closed: 5,
    populating: 6
  }

  def self.for(date, location)
    date_integer = date.to_s(:integer).to_i unless date.is_a?(Integer)
    where("start_date <= ? and end_date >= ?", date_integer, date_integer).
      where(location_id: location.id).first
  end

  def generate_company_preview
    save if id.blank?

    ScheduleLocationJob.new.perform(self.id, false)
    self.update(status: :scheduleless_approved)
  end

  def label
    [
      Date.parse(start_date.to_s).to_s(:month_day_year),
      Date.parse(end_date.to_s).to_s(:month_day_year)
    ].join(" - ")
  end

  private

  def next_date_for(day)
    # TODO: this function is duplicated, turn into its own class
    date  = Date.parse(day)
    # if the start day of the schedule is today, then use the full duration
    delta = date > Date.today ? 0 : (company.schedule_setting.schedule_duration * 7)
    date + delta
  end
end
