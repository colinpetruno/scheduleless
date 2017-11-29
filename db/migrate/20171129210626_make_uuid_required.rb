class MakeUuidRequired < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:public_companies, :uuid, false)
  end
end
