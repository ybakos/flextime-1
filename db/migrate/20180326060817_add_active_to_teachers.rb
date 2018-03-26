class AddActiveToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :active, :boolean, default: true, null: false
  end
end
