class CreatePublicReports < ActiveRecord::Migration[5.0]
  def change
    create_table :public_reports do |t|
      t.string :email
      t.string :name

      t.integer :role, null: false, default: 0
      t.date :incident_date
      t.string :accused
      t.boolean :still_happening
      t.string :committed_by
      t.text :what_happened, null: false
      t.boolean :did_you_respond, null: false, default: false
      t.boolean :notified_others, null: false, default: false
      t.integer :reported_to, null: false, default: 0
      t.boolean :experienced_retaliation, null: false, default: false
      t.boolean :job_affected, null: false, default: false
      t.text :job_affected_description
      t.text :others_present
      t.boolean :others_affected, null: false, default: false
      t.boolean :sought_treatment, null: false, default: false
      t.text :handled_description
      t.boolean :handled_satisified, null: false, default: false
      t.text :preferred_handling

      t.text :summary
      t.boolean :discussed
      t.string :uuid, null: false

      t.timestamps
    end
  end
end
