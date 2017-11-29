class SanitizedElasticsearchString
  def self.for(term)
    new(term).sanitize
  end

  def initialize(term)
    @term = term || ""
  end

  def sanitize
    @term.
      gsub("\\", ""). # this one needs to go first
      gsub("/", "\\/").
      gsub("||", "").
      gsub("]", "").
      gsub("(", "").
      gsub(")", "").
      gsub("[", "").
      gsub("]", "").
      gsub("{", "").
      gsub("}", "").
      gsub("&&", "").
      gsub("^", "").
      gsub("<", "").
      gsub("/j", "").
      gsub('"', "").
      gsub(">", "").
      gsub("+", "\\+").
      gsub(/[!@%&#^"~*?:]/,'')
  end

  # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#_reserved_characters
end
