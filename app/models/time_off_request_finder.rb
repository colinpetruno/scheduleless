class TimeOffRequestFinder
  def self.for(user)
    new(user: user)
  end

  def initialize(user:)
    @user = user
  end

  def locate
    TimeOffRequest.where(user_id: user.id).order(:start_date, :start_minutes)
  end

  private

  attr_reader :user
end
