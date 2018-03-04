class AddActiveToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :active, :boolean, null: false, default: true
  end
end
