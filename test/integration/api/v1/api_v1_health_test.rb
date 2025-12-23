require "test_helper"

class ApiV1HealthTest < ActionDispatch::IntegrationTest
  test "GET /api/v1/health returns ok" do
    get "/api/v1/health"
    assert_response :success
  end
end
