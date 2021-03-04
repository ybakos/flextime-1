require 'test_helper'

class SchoolTest < ActiveSupport::TestCase

  test 'without a name is invalid' do
    school = schools(:first)
    assert school.valid?
    school.name = nil
    refute school.valid?
  end

  test 'without a slug is invalid' do
    school = schools(:first)
    assert school.valid?
    school.slug = nil
    refute school.valid?
  end

  test 'with a non-unique slug is invalid' do
    existing_slug = schools(:first).slug
    school = School.new(name: 'Fake', slug: 'fake')
    assert school.valid?
    school.slug = existing_slug
    refute school.valid?
  end

  test 'has many users' do
    assert_respond_to schools(:first), :users
    assert_kind_of User, schools(:first).users.first
  end

  test 'has many activities' do
    assert_respond_to schools(:first), :activities
    assert_kind_of Activity, schools(:first).activities.first
  end

  test 'has many registrations' do
    assert_respond_to schools(:first), :registrations
    assert_kind_of Registration, schools(:first).registrations.first
  end

  test 'has many teachers' do
    assert_respond_to schools(:first), :teachers
    assert_kind_of Teacher, schools(:first).teachers.first
  end

  test 'has a string representation of name' do
    assert_equal schools(:first).to_s, schools(:first).name
  end

  test 'cannot be destroyed when it has teachers that have students/registrations' do
    school = schools(:first)
    refute school.destroy
    assert_raises(ActiveRecord::RecordNotDestroyed) { school.destroy! }
  end

  test 'destroys associated records when destroyed' do
    school = schools(:second)
    refute_empty school.users
    assert school.destroy
    assert_empty school.users
  end

  # See https://github.com/ErwinM/acts_as_tenant/issues/253
  # You would think that this would fail. Since the tenant is `schools(:first)`,
  # shouldn't school.users initially be empty? And shouldn't destroying the school
  # not cause the associated users to be deleted because .users should be scoped
  # to the tenant? Does this mean that, if you obtain the tenant, all bets are off?
  test 'acts_as_tenant' do
    ActsAsTenant.with_tenant(schools(:first)) do
      school = schools(:second)
      refute_empty school.users
      assert school.destroy
      assert_empty school.users
    end
    # Notice how this raises InvalidForeignKey and not RecordNotDestroyed.
    ActsAsTenant.with_tenant(schools(:second)) do
      school = schools(:first)
      assert_raises(ActiveRecord::InvalidForeignKey) { school.destroy }
    end
  end

end
