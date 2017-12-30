class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.references :creator, foreign_key: {to_table: :users}, null: false
      t.references :student, foreign_key: {to_table: :users}, index: true, null: false
      t.references :teacher, foreign_key: true, index: true, null: false
      t.references :activity, foreign_key: true, index: true, null: false

      t.timestamps
    end
    add_index :registrations, [:activity_id, :student_id], unique: true
  end
end
