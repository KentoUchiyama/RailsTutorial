require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  # ログインしていない状態でcreateメソッドが呼ばれた時の確認
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  # ログインしていない状態でdestroyメソッドが呼ばれた時の確認
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end