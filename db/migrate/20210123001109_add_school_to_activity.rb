class AddSchoolToActivity < ActiveRecord::Migration[5.2]
  def up
    add_reference :activities, :school, foreign_key: { on_delete: :cascade }
    initial_default_school = School.find_or_create_by(slug: 'defaultschool') { |s| s.name = 'Default School' }
    execute <<-SQL.squish
      UPDATE activities
      SET school_id = #{initial_default_school.id};
    SQL
    change_column_null :activities, :school_id, false
  end

  def down
    remove_reference :activities, :school
  end
end
