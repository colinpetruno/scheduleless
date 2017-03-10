class Schedule
  include ActiveModel::Model

  attr_accessor :company

  def self.for(company)
    new(company: company)
  end

  def generate

    # increment, do we schedule down to 15 mins, 30 mins, 1 hour etc
    # lunches? do we include lunches in the schedule are they paid or unpaid
    # what positions do we need to schedule for
    # how many people per position
    # what times are available to be scheduled for an employee
    #
    # take employees where this is their 'preferred location first'
    true
  end

end
