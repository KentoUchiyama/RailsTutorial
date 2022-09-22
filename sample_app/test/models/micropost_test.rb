require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
    end

  # マイクロポストの有効性テスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # マイクロポストの有効性テスト（ユーザIDがnilの場合）
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # マイクロポストの存在性テスト
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # マクロポストの文字数テスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # マイクロポストの順序付けテスト
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end