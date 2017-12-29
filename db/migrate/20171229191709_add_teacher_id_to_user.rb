class AddTeacherIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :teacher, foreign_key: true
  end
end
