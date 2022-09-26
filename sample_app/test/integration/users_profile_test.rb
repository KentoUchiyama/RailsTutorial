require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  # プロフィール表示のテスト
  test "profile display" do
    ## プロフィール画面にアクセス
    get user_path(@user)
    assert_template 'users/show'
    ## ページタイトル
    assert_select 'title', full_title(@user.name)
    ## ユーザ名
    assert_select 'h1', text: @user.name
    ## Gravatar
    assert_select 'h1>img.gravatar'
    ## マイクロポストの投稿数
    assert_match @user.microposts.count.to_s, response.body
    ## ページネーション
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'div.pagination', count: 1
    ## フォロー中、フォロワー
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
  end
end