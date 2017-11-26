class PublicReport < ApplicationRecord
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

end
