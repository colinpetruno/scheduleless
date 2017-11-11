class AddFinishedReviewToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :finished_review, :boolean, default: false, null: false
    add_column :reports, :finished_review_at, :datetime

    add_column :reports, :started_review, :boolean, default: false, null: false
    add_column :reports, :started_review_at, :datetime

    add_column :reports, :reviewed_by, :integer
  end
end
