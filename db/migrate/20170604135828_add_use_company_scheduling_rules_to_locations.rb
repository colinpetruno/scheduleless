class AddUseCompanySchedulingRulesToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :use_custom_scheduling_rules, :boolean, null: false, default: false
  end
end
