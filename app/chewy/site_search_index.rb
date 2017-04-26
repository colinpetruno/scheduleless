class SiteSearchIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      fuzzy_search: {
        tokenizer: "ngram_tokenizer",
        filter: ["lowercase", "nGram"]
      }
    },
    tokenizer: {
      ngram_tokenizer: {
        type: "nGram",
        min_gram: "3",
        max_gram: "8"
      }
    }
  }

  define_type User do
    field :email, analyzer: "fuzzy_search"
    field :given_name, analyzer: "fuzzy_search"
    field :family_name, analyzer: "fuzzy_search"
    field :preferred_name, analyzer: "fuzzy_search"
    field :company_id
  end

  define_type Location do
    field :line_1, analyzer: "fuzzy_search"
    field :line_2, analyzer: "fuzzy_search"
    field :city
    field :county_province
    field :postalcode
    field :name, analyzer: "fuzzy_search"
    field :country
    field :company_id
  end
end
