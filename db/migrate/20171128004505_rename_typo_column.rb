class RenameTypoColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :public_reports, :handled_satisified, :handled_satisfied
  end
end
