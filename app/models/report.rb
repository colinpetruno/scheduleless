class Report < ApplicationRecord
  belongs_to :user
  has_one :report_detail

  accepts_nested_attributes_for :report_detail

  def report_detail
    super || build_report_detail
  end
end
