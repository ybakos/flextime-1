class AddAttendanceToRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :attendance, :integer, default: 0, null: false
  end
end
