require "test_helper"

class ApiV1RootTest < ActionDispatch::IntegrationTest
  test "GET /api/v1 returns metadata" do
    get "/api/v1"
    assert_response :success

    json = JSON.parse(response.body)
    # Keep these assertions aligned with your actual payload.
    assert json.is_a?(Hash)
    assert_equal "v1", json["version"] if json.key?("version")
  end
end
