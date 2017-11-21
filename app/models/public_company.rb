class PublicCompany < ApplicationRecord
  update_index "company_search#public_company", :self

  def to_param
    "#{id}-harrassment-at-#{name.parameterize}"
  end
end
