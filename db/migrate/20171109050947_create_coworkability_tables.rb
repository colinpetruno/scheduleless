class CreateCoworkabilityTables < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false
      t.datetime :started_at
      t.boolean :completed, null: false, default: false

      t.timestamps
    end

    create_table :report_details do |t|
      t.references :report
      t.text :summary

      t.timestamps
    end

    create_table :incidents do |t|
      t.references :report

      t.integer :rating, null: false, default: 0
      t.integer :likelihood
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end
end
