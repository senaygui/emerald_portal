class Invoice < ApplicationRecord 
  validates :invoice_number, :presence => true
  validates :student_full_name, :presence => true

  belongs_to :student
  belongs_to :program
  belongs_to :batch
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_one :payment_transaction, as: :invoiceable, dependent: :destroy
  accepts_nested_attributes_for :payment_transaction, reject_if: :all_blank, allow_destroy: true
  has_many :invoice_items, as: :itemable, dependent: :destroy

  scope :recently_added, lambda { where("created_at >= ?", 1.week.ago) }
  scope :unpaid, lambda { where(invoice_status: "unpaid") }
  scope :pending, lambda { where(invoice_status: "pending") }
  scope :approved, lambda { where(invoice_status: "approved") }
  scope :denied, lambda { where(invoice_status: "denied") }
  scope :incomplete, lambda { where(invoice_status: "incomplete") }
  scope :due_date_passed, lambda { where("due_date < ?", Time.now) }

end
