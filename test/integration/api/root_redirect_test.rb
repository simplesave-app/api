require "test_helper"

class RootRedirectTest < ActionDispatch::IntegrationTest
  test "GET / redirects to /api/v1" do
    get "/"
    assert_response :redirect
    assert_redirected_to "/api/v1"
  end
end
