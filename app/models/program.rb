class Program < ApplicationRecord
     # #validations
    validates :program_name, presence: true, length: { within: 2..50 }
    validates :program_code, presence: true

   # #scope
     scope :recently_added, -> { where('created_at >= ?', 1.week.ago) }

    # #associations
    has_many :invoices
    has_many :batches
    has_many :student_grades
    has_many :courses
    has_many :students
    has_many :course_registrations
end
