class AddRegistrationsCountToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :registrations_count, :integer, default: 0

    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          UPDATE activities
          SET registrations_count = (SELECT count(*)
                                     FROM registrations
                                     WHERE registrations.activity_id = activities.id);
        SQL
      end
      direction.down do
        # Nothing extra. Just let the migration remove the column.
      end
    end
  end
end
