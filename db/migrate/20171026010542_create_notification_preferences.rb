class CreateNotificationPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_preferences do |t|
      t.references :user
      t.boolean :global_unsubscribe, null: false, default: false

      t.timestamps
    end
  end
end
