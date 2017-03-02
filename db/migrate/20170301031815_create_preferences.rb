class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :company_preferences do |t|
      t.references :company
      t.integer :shift_overlap, default: 15, null: false
    end
  end
end
