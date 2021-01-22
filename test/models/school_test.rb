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

end
