class CreatePlans< ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :plan_name
    end
  end
end
