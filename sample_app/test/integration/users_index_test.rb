require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  # ユーザ一覧画面のページネーションと削除リンクの確認
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    ## 最初のページにユーザが表示されること
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    # deleteリクエストを送信してユーザ数が減ること
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  # ユーザ一覧画面の一般ユーザの確認
  test "index as non-admin" do
    ## 削除リンクが表示されないこと
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end