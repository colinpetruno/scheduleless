class AddUseCompanyPreferenceToPreferences < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :use_company_settings, :boolean, null: false, default: true
  end
end
