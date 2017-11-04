class UserTableChanges < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at

    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    remove_column :users, :invitation_token
    remove_column :users, :invitation_created_at
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_type
    remove_column :users, :invited_by_id
    remove_column :users, :invitations_count

    add_column :users, :legal_gender, :boolean
    add_column :users, :date_of_birth, :integer
    add_column :users, :personal_phone, :integer
  end
end
