require 'application_system_test_case'

class TeachersTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  # Viewing

  test 'staff views a list of teachers' do
    sign_in users(:staff)
    visit teachers_url
    assert_selector 'h2', text: 'Teachers'
    assert_link 'Miss Valid'
  end

  # https://github.com/osu-cascades/falcon-time/issues/32
  test 'staff views a teacher and a list of student activities' do
    # see registrations test
  end

  test 'staff do not see modification links' do
    sign_in users(:staff)
    visit teachers_url
    assert_link 'Miss Valid'
    refute_link 'Edit'
    refute_link 'Delete'
    refute_link 'Deactivate', exact: true
  end

  test 'staff do not see creation form' do
    sign_in users(:staff)
    visit teachers_url
    refute_selector 'form#new_teacher'
  end

  # Creating

  test 'admin creates a teacher' do
    sign_in users(:admin)
    visit teachers_url
    select 'Miss', from: 'teacher_title'
    fill_in 'teacher_name', with: 'FAKE'
    click_button 'Create Teacher'
    assert_link 'Miss FAKE'
  end

  test 'admin sees an error when creating a teacher and neither a title nor name are specified' do
    sign_in users(:admin)
    visit teachers_url
    click_button 'Create Teacher'
    assert_text '2 errors prohibited this teacher from being saved'
    assert_text "Title can't be blank"
    assert_text "Name can't be blank"
  end

  # There can be only one "Mr. Smith"
  test 'admin sees an error when creating a teacher with a title/name pair matching an existing teacher' do
    sign_in users(:admin)
    visit teachers_url
    assert_selector 'h3', text: 'Miss Valid', count: 1
    select 'Miss', from: 'teacher_title'
    fill_in 'teacher_name', with: 'Valid'
    click_button 'Create Teacher'
    assert_text '1 error prohibited this teacher from being saved'
    assert_text 'Name has already been taken'
    assert_selector 'h3', text: 'Miss Valid', count: 1
  end

  # Updating

  def edit_first_teacher
    first('.list-group-item').click_link('Edit')
    assert_selector 'h2', text: 'Editing Mr. Fake'
  end

  test 'admin updates a teacher' do
    sign_in users(:admin)
    visit teachers_url
    edit_first_teacher
    fill_in 'teacher_name', with: 'FAKE UPDATE'
    click_button 'Update Teacher'
    assert_text 'Teacher was successfully updated'
    assert_selector 'h2', text: 'Mr. FAKE UPDATE'
  end

  test 'admin sees an error when updating a teacher and neither a title nor name are specified' do
    sign_in users(:admin)
    visit teachers_url
    edit_first_teacher
    select 'Choose...', from: 'teacher_title'
    fill_in 'teacher_name', with: ''
    click_button 'Update Teacher'
    assert_text '2 errors prohibited this teacher from being saved'
    assert_text "Title can't be blank"
    assert_text "Name can't be blank"
  end

  # There can be only one "Mr. Smith"
  test 'admin sees an error when updating a teacher with a title/name pair matching an existing teacher' do
    sign_in users(:admin)
    visit teachers_url
    edit_first_teacher
    select 'Mrs.', from: 'teacher_title'
    fill_in 'teacher_name', with: 'Fake'
    click_button 'Update Teacher'
    assert_selector 'h2', text: 'Editing Mr. Fake'
    assert_text '1 error prohibited this teacher from being saved'
    assert_text 'Name has already been taken'
  end

  # Deactivating

  # https://github.com/osu-cascades/falcon-time/issues/39
  test 'admin deactivates a teacher' do
    sign_in users(:admin)
    visit teachers_url
    # See teachers_controller_test.rb. Avoiding this here since the deactivate
    # link uses js to display a confirmation dialog. (slow test)
    # accept_confirm do
    #   first('.list-group-item').click_link('Deactivate')
    # end
    # assert_text 'Fake was successfully deactivated'
  end

  # Deleting

  test 'admin deletes a teacher with no students nor registrations' do
    skip
  end

  test 'admin sees an error when deleting a teacher with students' do
    skip
  end

  test 'admin sees an error when deleting a teacher with registrations' do
    skip
  end

end
