class PublicCompany < ApplicationRecord
  update_index "company_search#public_company", :self
end
