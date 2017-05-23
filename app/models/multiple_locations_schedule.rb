class MultipleLocationsSchedule
  def initialize(company:)
    @company = company
  end

  def schedules
    @_schedules ||= create
  end

  private

  attr_reader :company

  def create
   locations.each do |location|
      location_schedules.
        push(Scheduler::Schedule.for(company, location.users))
    end
  end

  def location_schedules
    @_location_schedules ||= []
  end

  def locations
    company.locations
  end
end
