class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.references :company, null: false
      t.string :name, null: false
    end
  end
end
