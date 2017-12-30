json.extract! registration, :id, :creator_id, :student_id, :teacher_id, :activity_id, :created_at, :updated_at
json.url registration_url(registration, format: :json)
