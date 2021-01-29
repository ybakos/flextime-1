class AddSchoolToUsers < ActiveRecord::Migration[5.2]
  def up
    add_reference :users, :school, foreign_key: true
    initial_default_school = School.create!(name: 'Default School', slug: 'defaultschool')
    execute <<-SQL.squish
      UPDATE users
      SET school_id = #{initial_default_school.id};
    SQL
    change_column_null :users, :school_id, false
  end

  def down
    remove_reference :users, :school
    School.find_by_slug('defaultschool').destroy!
  end
end
