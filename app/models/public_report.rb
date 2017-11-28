class PublicReport < ApplicationRecord
  before_create :generate_uuid
  validates :what_happened, presence: true

  enum category: {
    not_sure: 0,
    sexual_harassment: 1,
    sexual_assault: 2,
    racial_discrimination: 3,
    gender_discrimination: 4,
    harassment: 5,
    lgbt_discrimination: 6
  }

  enum role: {
    unclassified: 0,
    victim: 1,
    witness: 2,
    harasser: 3
  }

  enum reported_to: {
    no_one: 0,
    manager: 1,
    hr_dept: 2,
    other: 3
  }

  def self.category_options
    self.categories.keys.map do |category|
      [I18n.t("models.public_report.categories.#{category}"), category]
    end
  end

  def self.role_options
    self.roles.keys.map do |role|
      [I18n.t("models.public_report.roles.#{role}"), role]
    end
  end

  def self.reported_to_options
    self.reported_tos.keys.map do |person|
      [I18n.t("models.public_report.reported_to.#{person}"), person]
    end
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.hex(22)
  end
end
