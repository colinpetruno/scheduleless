class PopularTime < ApplicationRecord
  belongs_to :popular, polymorphic: true

  enum level: {
    lull: 0,
    normal: 1,
    busy: 2,
    peak: 3
  }
end
