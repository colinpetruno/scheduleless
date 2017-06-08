class SchedulingPeriod < ApplicationRecord
  belongs_to :company
  belongs_to :location
  belongs_to :user

  has_many :in_progress_shifts

  before_validation :set_end_date

  validates :end_date, presence: true
  validates :start_date, presence: true

  enum status: {
    empty: 0,
    generated: 1,
    scheduleless_approved: 2,
    company_approved: 3,
    published: 4,
    closed: 5
  }

  def generate_admin_preview
    save if id.blank?

    ScheduleLocationJob.new.perform(self.id)
    self.update(status: :generated)
  end

  def generate_company_preview
    save if id.blank?

    ScheduleLocationJob.new.perform(self.id)
    self.update(status: :scheduleless_approved)
  end

  def label
    [
      Date.parse(start_date.to_s).to_s(:month_day_year),
      Date.parse(end_date.to_s).to_s(:month_day_year)
    ].join(" - ")
  end

  private

  def set_end_date
    # TODO: this is bad, need to clean it up a bit, perhaps extract this into
    # its own class, the code is also in the schedule period options a little
    # bit
    #
    # TODO: if someone changes the scheduling day start, what happens? we need
    # to maintain a good continuity of schedules but right now it will probably
    # generate a super short schedule

    if end_date.blank?
      schedule_setting = company.schedule_setting
      start_date_date = Date.parse(start_date.to_s)

      if start_date_date.wday == schedule_setting.day_start
        end_date_date = start_date_date + (schedule_setting.schedule_duration * 7).days - 1.day
      else
        # TODO: This logic is screwed up. Need to find the beginning of this
        # scheduling period then add the duration
        end_date_date = next_date_for(schedule_setting.start_day_of_week) - 1.day
      end

      self.end_date = end_date_date.to_s(:integer).to_i
    end
  end

  def next_date_for(day)
    # TODO: this function is duplicated, turn into its own class
    date  = Date.parse(day)
    # if the start day of the schedule is today, then use the full duration
    delta = date > Date.today ? 0 : (company.schedule_setting.schedule_duration * 7)
    date + delta
  end
end
