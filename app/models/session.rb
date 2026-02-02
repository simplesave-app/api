class Session < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(revoked_at: nil).where("expires_at > ?", Time.current) }

  SESSION_TTL = 2.hours

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  def revoked?
    revoked_at.present?
  end

  def expired?
    expires_at < Time.current
  end

  def active?
    !revoked? && !expired?
  end

  def set_expiration
    self.expires_at ||= SESSION_TTL.from_now
  end

  def generate_token
    self.token ||= SecureRandom.hex(32)
  end
end
