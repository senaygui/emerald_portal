# Represents an administrator user in the system with authentication capabilities.
# This model handles authentication using Devise and includes user profile information.
#
# @!attribute first_name
#   @return [String] the user's first name
# @!attribute last_name
#   @return [String] the user's last name
# @!attribute role
#   @return [String] the user's role (e.g., 'admin', 'registrar', 'finance')
# @!attribute photo
#   @return [ActiveStorage::Attached] the user's profile photo
#
# @example Creating a new admin user
#   AdminUser.create!(email: 'admin@example.com', password: 'password', first_name: 'John', last_name: 'Doe', role: 'admin')
class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable
  has_person_name
  has_one_attached :photo, dependent: :destroy

  # #validations
  # validates :username, presence: true, length: { within: 2..50 }
  validates :first_name, presence: true, length: { within: 2..50 }
  validates :last_name, presence: true, length: { within: 1..50 }
  validates :role, presence: true

  # validates :photo, attached: true, content_type: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg']
  ## scope
  scope :recently_added, -> { where('created_at >= ?', 1.week.ago) }
  scope :total_users, -> { order('created_at DESC') }
  scope :admins, -> { where(role: 'admin') }
  scope :registrars, -> { where('role = ?', '%registrar%') }
  scope :finances, -> { where('role = ?', '%finance%') }
  def full_name
    [first_name, middle_name.presence, last_name.presence].compact.join(' ')
  end
end
