class AddNoteToScheduleSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :schedule_settings, :note, :text
  end
end
