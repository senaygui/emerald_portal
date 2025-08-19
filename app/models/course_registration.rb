class CourseRegistration < ApplicationRecord
  # after_create :add_invoice_item
  # validate :check_prerequisites
  # after_save :add_grade


  # #associations
  
  belongs_to :course
  has_many :invoice_items
  has_one :student_grade, dependent: :destroy
  belongs_to :student
  belongs_to :batch
  belongs_to :program


  validates :student_full_name, presence: true
  validates :enrollment_status, presence: true

 


  def add_grade
    if !student_grade.present?
      StudentGrade.create! do |student_grade|
        student_grade.course_registration_id = id
        student_grade.student_id = student.id
        student_grade.course_id = course.id
        student_grade.program_id = program.id
        student_grade.created_by = updated_by
      end
    end
  end

  private

  def check_prerequisites
    prerequisites = Prerequisite.where(course_id: self.course.id)

    prerequisites.each do |prerequisite|
      prerequisite_course = prerequisite.prerequisite
      student_grade = StudentGrade.find_by(student_id: self.student_id, course_id: prerequisite_course.id)

      if student_grade.nil? || student_grade.letter_grade == 'Falied' || student_grade.letter_grade == 'Incomplete'
        errors.add(:base, "You have not passed the prerequisite course #{prerequisite_course.course_title}.")
      end
    end
  end
end
