class CreateStudentCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :student_courses, id: :uuid do |t|
      t.belongs_to :student, index: true, type: :uuid
      t.belongs_to :course, index: true, type: :uuid
      t.string :course_title, null: false
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
