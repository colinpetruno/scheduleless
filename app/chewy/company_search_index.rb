class CompanySearchIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      fuzzy_search: {
        tokenizer: "ngram_tokenizer",
        # tokenizer: "ngram", # whitespace
        filter: ["standard", "lowercase"] # , "nGram"
       }
    },
    tokenizer: {
      ngram_tokenizer: {
        type: "nGram",
        min_gram: "3",
        max_gram: "12"
      }
    }
  }

  define_type PublicCompany do
    field :name, analyzer: "fuzzy_search"
  end
end
