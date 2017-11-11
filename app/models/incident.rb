class Incident < ApplicationRecord
  SCORE_MAP = {
    "0_1": 1,
    "0_2": 5,
    "0_3": 15,
    "1_1": 101,
    "1_2": 125,
    "1_3": 150,
    "2_1": 301,
    "2_2": 400,
    "2_3": 500,
    "3_1": 751,
    "3_2": 900,
    "3_3": 1050
  }

  before_save :set_score

  belongs_to :report
  belongs_to :user

  validates :likelihood, presence: true
  validates :rating, presence: true
  validates :report_id, presence: true
  validates :user_id, presence: true

  enum rating: {
    gray: 0,
    yellow: 1,
    orange: 2,
    red: 3
  }

  enum likelihood: {
    no_evidence: 1,
    circumstantial_evidence: 2,
    solid_evidence: 3
  }


  def self.rating_options
    Incident.ratings.keys.map do |key|
      [I18n.t("models.incidents.ratings.#{key}"), key]
    end
  end

  def self.likelihood_options
    Incident.likelihoods.keys.map do |key|
      [I18n.t("models.incidents.likelihoods.#{key}"), key]
    end
  end

  private

  def set_score
    likelihood_integer = Incident.likelihoods[self.likelihood]
    rating_integer = Incident.ratings[self.rating]

    self.score = SCORE_MAP["#{rating_integer}_#{likelihood_integer}".to_sym]
  end

  # rating
  # declines iwth amount of time
  # declines with each extra incident for user ( if someone reports someone
  # multiple times)
end
