class Cancellation
  attr_reader :shift

  def self.for(shift)
    new(shift: shift)
  end

  def initialize(shift:)
    @shift = shift
  end

  def cancel
    # TODO: Fill this in
    true
  end
end
