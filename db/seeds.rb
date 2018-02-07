# Teacher Seeds
[
  'Adkins',
  'Chaiet',
  'Clark',
  'Conant',
  'Galvin',
  'Hancock',
  'Henry',
  'Huddart',
  'Jones',
  'LaDuca',
  'Larson',
  'McAvoy',
  'Mooney',
  'Philiben',
  'Price',
  'Roberts',
  'Robinson',
  'Sanders',
  'Sato',
  'Schelske',
  'Schepergerdes',
  'Seguin',
  'Smith',
  'South',
  'Wognild',
  'Young'
].each do |name|
  Teacher.create(title: Random.new.rand(4), name: name)
end

# Activity Seeds

activity_names = [
  'LA red-do assignments and tests',
  'LA 6',
  'LA 7',
  'LA 8',
  'Math tutoring',
  'Science 7th Grade lab make ups',
  'Science 8th Grade lab make ups',
  'Social Studies tutoring',
  'Battle of the Books',
  'Chess',
  'Creative Coloring',
  'Volleyball',
  'Flag Football',
  'Kahoots!',
  'Movie Time',
  'Robotics',
  'Skate Park',
  'Band',
  '7th Grade Football Players ONLY',
  'Fellowship of Christian Athletes',
  'Be the Change Club',
  'Ping Pong',
  'Independent Drawing',
  'Study Hall',
  'Math re-do tests and assignments',
  'Orchestra 8',
  'Math re-do assignments and tests',
  'Math 6',
  'Math 7',
  'Math 8',
  'Math tutoring',
  'Science 6 lab make ups and tutoring',
  'Science 7 tutoring',
  'Science 8 tutoring',
  'LA tutoring',
  'Social Studies tutoring',
  'Battle of the Books',
  'Orchestra 7',
  'Board Games',
  'Card Games',
  'Chess',
  'Volleyball',
  'Flag Football',
  'Creative Coloring',
  'Movie Time',
  'Robotics',
  'Skate Park',
  'Band',
  'Kahoot! and Quizlet Live',
  'Culture Club',
  'Be the Change Club',
  'Ping Pong',
  'Independent Drawing',
  'Study Hall',
  'Gay-Straight Alliance',
  'Muse Club for Girls',
  'Science 6',
  'Science 7 test make ups and tutoring',
  'Science 8 test make ups and tutoring',
  'Social Studies 6',
  'Social Studies 7',
  'Social Studies 8',
  'LA tutoring',
  'Math tutoring',
  'Organization Skills',
  'Orchestra 6',
  'Board Games',
  'Chess',
  'Volleyball',
  'Flag Football',
  'Improv Drama',
  'Movie Time',
  'Kahoot!',
  'Skate Park',
  'Band',
  'American Sign Language',
  'Be the Change Club',
  'French Club',
  'Ping Pong',
  'Independent Drawing',
  'Study Hall',
  'Green Team Club',
  'Creative Writing and Journaling'
]

rooms = [
  '101',
  '102',
  '103',
  '104',
  '105',
  '106',
  '201',
  '202',
  '203',
  '204',
  '206',
  '301',
  '302',
  '304',
  '403',
  '404',
  '406',
  '502',
  'Art Room',
  'Band Room',
  'GYM',
  'Library',
  'Library Lounge',
  'Orchestra',
  'Tech Lab'
]

capacity = (10..26).to_a

10.times do |i|
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.tuesday)
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.thursday)
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.friday)

  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.prev_week.tuesday)
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.prev_week.thursday)
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.prev_week.friday)

  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.next_week.tuesday)
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.next_week.thursday)
  Activity.create(name: activity_names.sample, room: rooms.sample, capacity: capacity.sample, date: Date.today.next_week.friday)
end

all_teachers = Teacher.all

100.times do |i|
  User.create(email: "example#{i}@example.com", password: 'password', password_confirmation: 'password', provider: 'FAKE', uid: "FAKE#{i}", first_name: 'Example', last_name: "Student #{i}", teacher: all_teachers.sample)
end

all_students = User.student
all_activities = Activity.all


400.times do |i|
  student = all_students.sample
  Registration.create(creator: student, student: student, teacher: student.teacher, activity: all_activities.sample)
end
