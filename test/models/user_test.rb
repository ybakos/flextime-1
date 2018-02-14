require 'test_helper'
require 'minitest/mock'

class UserTest < ActiveSupport::TestCase

  def new_user
    User.new(email: 'new_fake_user@example.com',
      password: 'password', password_confirmation: 'password',
      first_name: 'New Fake', last_name: 'User')
  end

  def fake_allowable_domains
    ['fake.com']
  end

  # OMG!
  def mock_auth(domain)
    mock = MiniTest::Mock.new
    mock.expect(:extra, MiniTest::Mock.new.expect(:raw_info, MiniTest::Mock.new.expect(:hd, domain)))
    mock.expect(:provider, 'fake provider')
    mock.expect(:provider, 'fake provider')
    mock.expect(:uid, 'fake uid')
    mock.expect(:uid, 'fake uid')
    mock_info = MiniTest::Mock.new
    mock_info.expect(:email, 'fake@fake.com')
    mock_info.expect(:first_name, 'Fake')
    mock_info.expect(:last_name, 'Fake')
    mock_info.expect(:image, 'Fake')
    mock.expect(:info, mock_info)
    mock.expect(:info, mock_info)
    mock.expect(:info, mock_info)
    mock.expect(:info, mock_info)
  end

  test 'has a required first name' do
    u = new_user
    assert u.valid?
    u.first_name = ''
    refute u.valid?
  end

  test 'has a required last name' do
    u = new_user
    assert u.valid?
    u.last_name = ''
    refute u.valid?
  end

  test 'has a default role of student' do
    new_user = User.new
    assert_equal new_user.role, 'student'
  end

  test 'pre-existing User without defined role has a default role of student' do
    assert_equal users(:unknown).role, 'student'
  end

  test 'belongs to a teacher' do
    assert_respond_to users(:student), :teacher
    assert_kind_of Teacher, users(:student).teacher
  end

  test 'non-student does not have to have a teacher' do
    [users(:staff), users(:admin)].each { |u| u.teacher = nil; assert u.valid? }
  end

  test 'new student does not have to have a teacher' do
    new_student = new_user
    assert new_student.student?
    assert new_student.new_record?
    new_student.teacher = nil
    assert new_student.valid?
    assert_nothing_raised { new_student.save! }
  end

  test 'non-new student must have a teacher' do
    student = users(:student)
    assert student.valid?
    student.teacher = nil
    assert student.invalid?
  end

  test 'has many registrations' do
    assert_respond_to users(:student), :registrations
    assert_kind_of Registration, users(:student).registrations.first
  end

  test 'has a string representation of first_name last_name' do
    assert_equal users(:student).to_s, 'Fake Student'
  end

  test '#activity_for_day_of_week' do
    assert_equal users(:student).activity_for_day_of_week(:tuesday, Date.today.monday),
      registrations(:by_student).activity
  end

  test '::from_omniauth returns nil when auth object does not provide allowable hosted domain' do
    assert_nil User.from_omniauth(nil, fake_allowable_domains)
    assert_nil User.from_omniauth(mock_auth(''), fake_allowable_domains)
  end

  test '::from_omniauth returns User when auth object provides allowable hosted domain' do
    assert_instance_of User, User.from_omniauth(mock_auth(fake_allowable_domains.first), fake_allowable_domains)
  end

end
