class Report < ApplicationRecord
  belongs_to :user
  has_one :report_detail
end
