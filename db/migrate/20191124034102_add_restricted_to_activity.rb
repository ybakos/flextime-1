class AddRestrictedToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :restricted, :boolean, default: false, null: false
  end
end
