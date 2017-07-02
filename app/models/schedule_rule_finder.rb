class ScheduleRuleFinder
  # TODO: Test me
  def self.for(location)
    new(location: location).locate
  end

  def initialize(location:)
    @location = location
  end

  def locate
    if location.use_custom_scheduling_rules?
      location.schedule_rules
    else
      location.company.schedule_rules
    end
  end

  private

  attr_reader :location
end
