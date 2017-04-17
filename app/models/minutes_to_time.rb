class MinutesToTime
  def self.for(minutes)
    new(minutes: minutes).to_s
  end

  def initialize(minutes:)
    # TODO add max amount of 1440 here
    @minutes = minutes
  end

  def to_s(format: "%l:%M %p")
    time.strftime(format).strip
  end

  def time
    Time.at(minutes*60).utc
  end

  private

  attr_reader :minutes
end
