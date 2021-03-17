require 'test_helper'

class TeachersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test 'requires user authentication' do
    assert defines_before_filter?(TeachersController, :authenticate_user!)
  end

  test 'redirects requests from unauthenticated sessions' do
    # index
    get teachers_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # show
    get teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # edit
    get edit_teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # create
    post teachers_path
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # update
    patch teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    put teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # activate
    put activate_teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # deactivate
    put deactivate_teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
    # destroy
    delete teacher_path(id: 'fake')
    assert_redirected_to(controller: 'devise/sessions', action: 'new')
  end

  test 'restricts student access' do
    assert defines_before_filter?(TeachersController, :restrict_from_students)
  end

  test 'redirects requests from student users to student view' do
    student = users(:student)
    sign_in student
    # index
    get teachers_path
    assert_redirected_to student_path(student)
    # show
    get teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # edit
    get edit_teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # create
    post teachers_path
    assert_redirected_to student_path(student)
    # update
    patch teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    put teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # activate
    put activate_teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # deactivate
    put deactivate_teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
    # destroy
    delete teacher_path(id: 'fake')
    assert_redirected_to student_path(student)
  end

  test 'restricts staff access' do
    assert defines_before_filter?(TeachersController, :restrict_unless_admin)
  end

  test 'redirects requests from staff users to activities url' do
    sign_in users(:staff)
    # edit
    get edit_teacher_path(id: 'fake')
    assert_redirected_to activities_url
    # create
    post teachers_path
    assert_redirected_to activities_url
    # update
    patch teacher_path(id: 'fake')
    assert_redirected_to activities_url
    put teacher_path(id: 'fake')
    assert_redirected_to activities_url
    # activate
    put activate_teacher_path(id: 'fake')
    assert_redirected_to activities_url
    # deactivate
    put deactivate_teacher_path(id: 'fake')
    assert_redirected_to activities_url
    # destroy
    delete teacher_path(id: 'fake')
    assert_redirected_to activities_url
  end

  test 'allows admins to activate a teacher' do
    sign_in users(:admin)
    teacher = teachers(:deactivated)
    put activate_teacher_path(teacher)
    assert_redirected_to teachers_path
    assert_match /Teacher was successfully activated/, flash[:notice]
  end

  test 'allows admins to deactivate a teacher' do
    sign_in users(:admin)
    teacher = teachers(:miss_valid)
    put deactivate_teacher_path(teacher)
    assert_redirected_to teachers_path
    assert_match /Teacher was successfully deactivated/, flash[:notice]
  end

  test 'allows admins to delete a teacher' do
    sign_in users(:admin)
    teacher = teachers(:mr_fake)
    delete teacher_path(teacher)
    assert_redirected_to teachers_path
    assert_match /#{teacher.name} was successfully deleted/, flash[:notice]
  end


  # Multi-tenancy

  test 'redirects requests for another school\'s teacher' do
    sign_in users(:second_admin)
    other_school_teacher = teachers(:third_school_teacher)
    # show
    get teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
    # edit
    get edit_teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
    # update
    patch teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
    put teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
    # Note: These three are bad tests because a successful action will redirect
    # to teachers_path too. (!)
    # activate
    put activate_teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
    # deactivate
    put deactivate_teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
    # destroy
    delete teacher_path(other_school_teacher)
    assert_redirected_to teachers_path
  end

end
