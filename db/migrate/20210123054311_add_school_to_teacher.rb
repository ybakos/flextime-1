class AddSchoolToTeacher < ActiveRecord::Migration[5.2]
  def up
    add_reference :teachers, :school, foreign_key: true
    initial_default_school = School.find_or_create_by(slug: 'defaultschool') { |s| s.name = 'Default School' }
    execute <<-SQL.squish
      UPDATE teachers
      SET school_id = #{initial_default_school.id};
    SQL
    change_column_null :teachers, :school_id, false
  end

  def down
    remove_reference :teachers, :school
  end
end
