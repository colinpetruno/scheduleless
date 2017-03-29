class SiteSearchIndex < Chewy::Index
  define_type User do
    field :email
    field :given_name, :family_name
    field :preferred_name
    field :company_id
  end

  define_type Location do
    field :line_1, :line_2
    field :city
    field :county_province
    field :postalcode
    field :name
    field :country
    field :company_id
  end
end
