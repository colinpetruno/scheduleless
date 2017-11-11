class Report < ApplicationRecord
  belongs_to :user
  has_one :report_detail
  has_many :incidents

  accepts_nested_attributes_for :report_detail

  def self.claimed_by(user)
    where(started_review: true, finished_review: false, reviewed_by: user.id).
      includes(:user)
  end

  def self.unclaimed
    where(started_review: false).includes(:user)
  end

  def start(user)
    return if self.started_review?

    update(started_review: true,
           started_review_at: DateTime.now,
           reviewed_by: user.id)
  end

  def report_detail
    super || build_report_detail
  end
end
