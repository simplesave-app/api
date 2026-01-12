require "test_helper"

class SessionTest < ActiveSupport::TestCase
  def setup
    @user = users(:alice)
  end

  def test_fixture_session_is_active
    session = sessions(:alice_session)

    assert session.active?
    assert_equal @user, session.user
  end

  def test_token_is_generated_on_create
    session = Session.create!(user: @user, token: SecureRandom.hex(32))

    assert session.token.present?
  end

  def test_token_is_unique
    existing = Session.create!(user: @user, token: SecureRandom.hex(32))

    duplicate = Session.new(
      user: @user,
      token: existing.token,
      expires_at: 30.days.from_now
    )

    refute duplicate.valid?
    assert_includes duplicate.errors[:token], "has already been taken"
  end

  def test_expired_session
    session = Session.new(
      user: @user,
      expires_at: 1.hour.ago
    )

    assert session.expired?
    refute session.active?
  end

  def test_revoked_session
    session = Session.new(
      user: @user,
      revoked_at: Time.current
    )

    assert session.revoked?
    refute session.active?
  end

  def test_active_scope_excludes_revoked_and_expired_sessions
    active = Session.create!(user: @user, token: SecureRandom.hex(32))
    expired = Session.create!(
      user: @user,
      token: SecureRandom.hex(32),
      expires_at: 1.hour.ago
    )
    revoked = Session.create!(
      user: @user,
      token: SecureRandom.hex(32),
      revoked_at: Time.current
    )

    assert_includes Session.active, active
    refute_includes Session.active, expired
    refute_includes Session.active, revoked
  end
end
