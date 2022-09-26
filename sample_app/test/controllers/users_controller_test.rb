require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # newメソッドの確認
  test "should get new" do
    get signup_path
    assert_response :success
  end

  # ログアウト状態でeditメソッドが呼ばれた時の確認
  test "should redirect edit when not logged in" do
    ## ログイン画面にリダイレクトされてflashメッセージが表示されること
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # ログアウト状態でupdateメソッドが呼ばれた時の確認
  test "should redirect update when not logged in" do
    ## ログイン画面にリダイレクトされてflashメッセージが表示されること
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # ログイン済みのユーザが別のユーザの編集画面に遷移しようとした時の確認
  test "should redirect edit when logged in as wrong user" do

    # ルートURLにリダイレクトしてflashメッセージが表示されること
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # ログイン済みのユーザが別のユーザの更新をしようとした時の確認
  test "should redirect update when logged in as wrong user" do

    # ルートURLにリダイレクトしてflashメッセージが表示されること
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # admin属性の変更が禁止されていることの確認
  test "should not allow the admin attribute to be edited via the web" do

    ## 管理者権限ではないユーザでログイン
    log_in_as(@other_user)
    assert_not @other_user.admin?

    ## admin属性を変更するリクエストを送信
    patch user_path(@other_user), params: {
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  # indexメソッドの確認
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # ログインしていない状態でdestroyメソッドが呼ばれた時の確認
  test "should redirect destroy when not logged in" do
    ## 削除が実行されず、ログイン画面にリダイレクトされること
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # 一般ユーザでdestroyメソッドが呼ばれた時の確認
  test "should redirect destroy when logged in as a non-admin" do
    ## 削除が実行されず、ホーム画面にリダイレクトされること
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # ログアウト状態でfollowingページにアクセスした時の確認
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  # ログアウト状態でfollowersページにアクセスした時の確認
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
