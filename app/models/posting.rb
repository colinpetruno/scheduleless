class Posting < ApplicationRecord
  belongs_to :location
  belongs_to :user

  def date_end=(date)
    if date.is_a? String
      formatted_date = Date.parse(date)
    else
      formatted_date = date
    end

    super(formatted_date.to_s(:integer))
  end

  def date_start=(date)
    if date.is_a? String
      formatted_date = Date.parse(date)
    else
      formatted_date = date
    end

    super(formatted_date.to_s(:integer))
  end
end
