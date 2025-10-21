class ContactFormSubmission < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :message, presence: true

  # Enum for delivery status (if column exists)
  # enum :delivery_status, { pending: 0, sent: 1, failed: 2 }, default: :pending

  # Callbacks
  before_create :set_submitted_at

  private

  def set_submitted_at
    self.submitted_at ||= Time.current
  end
end
