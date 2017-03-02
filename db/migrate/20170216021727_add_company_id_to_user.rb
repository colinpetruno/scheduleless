class AddCompanyIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :company, index: true
  end
end
