# Represents a course in the learning management system.
#
# @attr [String] course_code Unique identifier for the course
# @attr [String] course_title Title of the course
# @attr [Text] course_description Detailed description of the course
# @attr [Integer] course_order Display order of the course
# @attr [Decimal] course_price Price of the course
# @attr [Integer] created_by ID of the user who created the course
# @attr [Integer] last_updated_by ID of the user who last updated the course
class Course < ApplicationRecord
  # validations
  validates :course_code, presence: true
  validates :course_title, presence: true
  validates :course_description, presence: true
  validates :course_order, presence: true
  validates :course_price, presence: true
  validates :created_by, presence: true
  validates :last_updated_by, presence: true

  ## associations
  belongs_to :program
  has_many :student_grades, dependent: :destroy
  has_many :student_courses, dependent: :destroy
  has_many :course_registrations, dependent: :destroy
  has_many :invoice_items
  has_many :attendances, dependent: :destroy
  has_one_attached :course_outline, dependent: :destroy
  has_many :assessment_plans, dependent: :destroy
  accepts_nested_attributes_for :assessment_plans, allow_destroy: true
  has_many :course_instructors
  accepts_nested_attributes_for :course_instructors, reject_if: :all_blank, allow_destroy: true
  has_many :course_prerequisites, class_name: 'Prerequisite'
  has_many :prerequisites, through: :course_prerequisites, source: :prerequisite
  accepts_nested_attributes_for :course_prerequisites, reject_if: :all_blank, allow_destroy: true

  # scope

  scope :recently_added, -> { where('created_at >= ?', 1.week.ago) }
  scope :by_program, ->(program_id) { where(program_id: program_id) }
end
