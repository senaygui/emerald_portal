class CoursesController < ApplicationController
  def index
    @courses = StudentCourse.where(student_id: current_student).order(created_at: :asc)
  end
end
