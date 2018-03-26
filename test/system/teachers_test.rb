require 'application_system_test_case'

class TeachersTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:staff)
    visit teachers_url
  end

  # Viewing

  test 'staff views a list of teachers' do
    assert_selector 'h2', text: 'Teachers'
    assert_link 'Miss Valid'
  end

  # https://github.com/osu-cascades/falcon-time/issues/32
  test 'staff views a teacher and a list of student activities' do
    # see registrations test
  end

  # Creating

  test 'staff creates a teacher' do
    select 'Miss', from: 'teacher_title'
    fill_in 'teacher_name', with: 'FAKE'
    click_button 'Create Teacher'
    assert_link 'Miss FAKE'
  end

  test 'staff sees an error when creating a teacher and neither a title nor name are specified' do
    click_button 'Create Teacher'
    assert_text '2 errors prohibited this teacher from being saved'
    assert_text "Title can't be blank"
    assert_text "Name can't be blank"
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

  # Updating

  def edit_first_teacher
    first('.list-group-item').click_link('Edit')
    assert_selector 'h2', text: 'Editing Mrs. Fake'
  end

  test 'staff updates a teacher' do
    edit_first_teacher
    fill_in 'teacher_name', with: 'FAKE UPDATE'
    click_button 'Update Teacher'
    assert_text 'Teacher was successfully updated'
    assert_selector 'h2', text: 'Mrs. FAKE UPDATE'
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

  # There can be only one "Mr. Smith"
  test 'staff sees an error when updating a teacher with a title/name pair matching an existing teacher' do
    edit_first_teacher
    select 'Mr.', from: 'teacher_title'
    fill_in 'teacher_name', with: 'Fake'
    click_button 'Update Teacher'
    assert_selector 'h2', text: 'Editing Mrs. Fake'
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

end
