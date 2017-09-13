class AddPublishedToInProgressShift < ActiveRecord::Migration[5.0]
  def change
    add_column :in_progress_shifts, :published, :boolean, default: false, null: false
  end
end
