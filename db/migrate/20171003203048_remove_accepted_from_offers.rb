class RemoveAcceptedFromOffers < ActiveRecord::Migration[5.0]
  def change
    remove_column :offers, :accepted

    add_column :offers, :accepted_or_declined_at, :datetime
    add_column :offers, :approved_by, :integer
  end
end
