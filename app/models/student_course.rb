class StudentCourse < ApplicationRecord
  belongs_to :student
  belongs_to :course

  # Add validations if needed, e.g.:
  # validates :student_id, presence: true
  # validates :course_id, presence: true
end
