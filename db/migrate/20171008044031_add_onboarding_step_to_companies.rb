class AddOnboardingStepToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :onboarding_step, :integer, null: false, default: 0
  end
end
