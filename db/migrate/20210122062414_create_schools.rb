class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end
    add_index :schools, :slug, unique: true
  end
end
