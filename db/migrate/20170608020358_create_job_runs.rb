class CreateJobRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduled_task_runs do |t|
      t.string :name, null: false
      t.boolean :failed, null: false, defaut: false

      t.text :output

      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
