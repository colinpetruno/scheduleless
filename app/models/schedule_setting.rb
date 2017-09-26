class ScheduleSetting
  include ActiveModel::Model

  attr_accessor :company, :start_day, :payment_method

  def update
    # binding.pry
    company.update(schedule_start_day: start_day, pay_by_type: payment_method)
  end

  def self.day_options
    I18n.t("date.day_names").each_with_index.map do |day, index|
      [day, index]
    end
  end

  def self.pay_method_options
    [["User", "user"], ["Position", "position"]]
  end
end
