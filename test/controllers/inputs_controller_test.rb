require "test_helper"

class InputsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inputs_index_url
    assert_response :success
  end
end
