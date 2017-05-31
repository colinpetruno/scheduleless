class CreateLeadsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :leads do |t|
      t.references :user
      t.integer :preferred_contact, null: false, default: 0
      t.text :note

      t.timestamps
    end
  end
end
