require "application_system_test_case"

class TeachersTest < ApplicationSystemTestCase

  setup do
    visit teachers_url
  end

  test 'students cannot CRUD teachers' do
    skip
  end

  test 'staff views a list of teachers' do
    assert_selector 'h2', text: 'Teachers'
    assert_link 'Miss Valid'
  end

  test 'staff creates a teacher' do
    select 'Miss', from: 'teacher_title'
    fill_in 'teacher_name', with: 'FAKE'
    click_button 'Create Teacher'
    assert_link 'Miss FAKE'
  end

  # There can be only one "Mr. Smith"
  test 'staff sees an error when creating a teacher with a title/name pair matching an existing teacher' do
    assert_selector 'h3', text: 'Miss Valid', count: 1
    select 'Miss', from: 'teacher_title'
    fill_in 'teacher_name', with: 'Valid'
    click_button 'Create Teacher'
    assert_text '1 error prohibited this teacher from being saved'
    assert_text 'Name has already been taken'
    assert_selector 'h3', text: 'Miss Valid', count: 1
  end

  test 'staff sees an error when creating a teacher and neither a title nor name are specified' do
    click_button 'Create Teacher'
    assert_text '2 errors prohibited this teacher from being saved'
    assert_text "Title can't be blank"
    assert_text "Name can't be blank"
  end

  def edit_first_teacher
    first('.list-group-item').click_link('Edit')
    assert_selector 'h2', text: 'Editing Mr. Fake'
  end

  test 'staff updates a teacher' do
    edit_first_teacher
    fill_in 'teacher_name', with: 'FAKE UPDATE'
    click_button 'Update Teacher'
    assert_text 'Teacher was successfully updated'
    assert_selector 'h2', text: 'Mr. FAKE UPDATE'
  end

  # There can be only one "Mr. Smith"
  test 'staff sees an error when updating a teacher with a title/name pair matching an existing teacher' do
    edit_first_teacher
    select 'Mrs.', from: 'teacher_title'
    fill_in 'teacher_name', with: 'Fake'
    click_button 'Update Teacher'
    assert_text '1 error prohibited this teacher from being saved'
    assert_text 'Name has already been taken'
    assert_selector 'h2', text: 'Editing Mrs. Fake' # UX smell. See https://github.com/osu-cascades/falcon-time/issues/28
  end

  test 'staff sees an error when updating a teacher and neither a title nor name are specified' do
    edit_first_teacher
    select 'Choose...', from: 'teacher_title'
    fill_in 'teacher_name', with: ''
    click_button 'Update Teacher'
    assert_text '2 errors prohibited this teacher from being saved'
    assert_text "Title can't be blank"
    assert_text "Name can't be blank"
  end

  test 'staff deletes a teacher' do
    first('.list-group-item').click_link('Delete')
    assert_no_link 'Mr. Fake'
  end

  # https://github.com/osu-cascades/falcon-time/issues/27
  test 'staff cannot delete a teacher that has students' do
    skip
  end

end
