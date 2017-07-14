class CreatePlanFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :plan_features do |t|
      t.references :plan
      t.references :feature
    end
  end
end
