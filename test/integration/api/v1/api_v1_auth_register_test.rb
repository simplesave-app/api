require "test_helper"

class ApiV1AuthRegisterTest < ActionDispatch::IntegrationTest
  def setup
    # Start from a clean state before each test, each test does its setup.
    Session.delete_all
    User.delete_all
  end

  test "register creates a user and a session" do
    assert_difference [ "User.count", "Session.count" ], +1 do
      post "/api/v1/auth/register", params: {
        user: {
          email: "alice@example.com",
          password: "securepassword",
          password_confirmation: "securepassword"
        }
      }
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert body["token"].present?, "expected response to include a session token"
    assert_equal "alice@example.com", body.dig("user", "email")
  end

  test "register with existing email returns error" do
    existing_user = User.create!(
      email: "alice@example.com",
      password: "securepassword",
      password_confirmation: "securepassword"
    )

    assert_no_difference [ "User.count", "Session.count" ] do
      post "/api/v1/auth/register", params: {
        user: {
          email: existing_user.email,
          password: "anotherpassword",
          password_confirmation: "anotherpassword"
        }
      }
    end

    assert_response :unprocessable_entity
    assert JSON.parse(response.body)["errors"].present?, "expected response to include errors"
  end

  test "register with mismatched password confirmation returns error" do
    post "/api/v1/auth/register", params: {
      user: {
        email: "alice@example.com",
        password: "securepassword",
        password_confirmation: "differentpassword"
      }
    }

    assert_response :unprocessable_entity
    assert JSON.parse(response.body)["errors"].present?, "expected response to include errors"
  end

  test "register with invalid email returns error" do
    post "/api/v1/auth/register", params: {
      user: {
        email: "invalid-email",
        password: "securepassword",
        password_confirmation: "securepassword"
      }
    }

    assert_response :unprocessable_entity
    assert JSON.parse(response.body)["errors"].present?, "expected response to include errors"
  end

  test "register with short password returns error" do
    post "/api/v1/auth/register", params: {
      user: {
        email: "alice@example.com",
        password: "short",
        password_confirmation: "short"
      }
    }

    assert_response :unprocessable_entity
    assert JSON.parse(response.body)["errors"].present?, "expected response to include errors"
  end

  test "register with missing parameters returns error" do
    post "/api/v1/auth/register", params: {}
    assert_response :unprocessable_entity
    assert JSON.parse(response.body)["errors"].present?, "expected response to include errors"
  end

  test "register with non-POST method returns method not allowed" do
    get "/api/v1/auth/register"
    assert_response :not_found
  end
end
