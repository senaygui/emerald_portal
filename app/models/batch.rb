class Batch < ApplicationRecord
    # #validations
    validates :batch_title, presence: true
    validates :starting_date, presence: true
    validates :ending_date, presence: true

     # #scope
     scope :recently_added, -> { where('created_at >= ?', 1.week.ago) }

    ## associations
    has_many :students
    has_many :course_registrations
    has_many :invoices
    belongs_to :program
end
