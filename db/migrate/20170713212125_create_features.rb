class CreateFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :features do |t|
      t.string :key, null: false
      t.string :description
    end
  end
end
