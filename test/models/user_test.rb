require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with email and password" do
    user = User.new(
      email: "newuser@example.com",
      password: TestCredentials::DEFAULT_PASSWORD,
      password_confirmation: TestCredentials::DEFAULT_PASSWORD
    )

    assert user.valid?
  end

  test "is invalid without email" do
    user = User.new(
      password: TestCredentials::DEFAULT_PASSWORD,
      password_confirmation: TestCredentials::DEFAULT_PASSWORD
    )

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "is invalid without password" do
    user = User.new(email: "nopassword@example.com")

    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "email must be unique" do
    existing_user = users(:alice)

    duplicate = User.new(
      email: existing_user.email,
      password: TestCredentials::DEFAULT_PASSWORD,
      password_confirmation: TestCredentials::DEFAULT_PASSWORD
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "authenticates with correct password" do
    user = users(:alice)

    assert user.authenticate(TestCredentials::DEFAULT_PASSWORD)
  end

  test "does not authenticate with incorrect password" do
    user = users(:alice)

    assert_not user.authenticate("wrong-password")
  end
end
