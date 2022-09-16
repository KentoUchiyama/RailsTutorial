require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  
  # newメソッドの確認
  test "should get new" do
    get login_path
    assert_response :success
  end

end
