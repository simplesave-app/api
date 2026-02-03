require "test_helper"

class ApiV1AuthLoginTest < ActionDispatch::IntegrationTest
  def setup
    Session.delete_all
    User.delete_all
  end

  test "username and password provided is correct" do
    user = User.create!(email: "test@example.com", password: "password")

    post "/api/v1/auth/login", params: {
      user: {
        email: "test@example.com",
        password: "password"
      }
    }

    assert_response :success
    body = JSON.parse(response.body)
    assert body["token"].present?, "expected response to include a session token"
    assert_equal user.id, body["user_id"]
  end

  test "session is created upon successful login" do
    user = User.create!(email: "test@example.com", password: "password")

    assert_difference "Session.count", 1 do
      post "/api/v1/auth/login", params: {
        user: {
          email: "test@example.com",
          password: "password"
        }
      }
    end
  end

  test "incorrect password" do
    User.create!(email: "test@example.com", password: "password")

    post "/api/v1/auth/login", params: {
      user: {
        email: "test@example.com",
        password: "wrongpassword"
      }
    }

    assert_response :unauthorized
  end

  test "non-existent email" do
    post "/api/v1/auth/login", params: {
      user: {
        email: "nonexistent@example.com",
        password: "password"
      }
    }

    assert_response :unauthorized
  end

  test "missing parameters" do
    post "/api/v1/auth/login", params: {}

    assert_response :unauthorized
    assert_equal "Invalid email or password", JSON.parse(response.body)["error"]
  end
end
