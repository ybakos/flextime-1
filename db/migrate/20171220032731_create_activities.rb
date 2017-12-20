class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.string :room, null: false
      t.integer :capacity, null: false
      t.date :date, null: false

      t.timestamps
    end
    add_index :activities, [:date, :name, :room], unique: true
  end
end
