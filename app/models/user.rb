class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # Role enum
  enum role: {
    parent: 0,
    student: 1,
    tutor: 2,
    administrator: 3
  }

  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true
  validates :phone_number, format: { with: /\A\+?[0-9\s\-()]+\z/, allow_blank: true }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  # Scopes
  scope :active, -> { where(active: true, deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :by_role, ->(role) { where(role: role) }
end
