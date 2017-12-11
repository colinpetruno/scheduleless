class CompanyInquiry < ApplicationRecord
  validates_presence_of :first_name, :last_name, :job_title, :company_name
end
