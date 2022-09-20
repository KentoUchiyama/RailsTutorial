require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    # 有効なユーザのfixtureを取得
    @user = users(:michael)
  end

  # ユーザログインに失敗した時のテスト
  test "login with invalid information" do

    ## ログイン画面が表示されること
    get login_path
    assert_template 'sessions/new'

    ## 無効なログイン情報でログインに失敗（ログイン画面再表示＆フラッシュメッセージあり）すること
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?

    ## 別のページに遷移したときにエラーメッセージが消えること
    get root_path
    assert flash.empty?
  end

  # ユーザログインに成功した時のテスト（ログアウトの確認も含む）
  test "login with valid information followed by logout" do

    ## 有効なログイン情報でログイン後の画面に遷移すること
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    
    ## 画面内のリンクがログイン後の状態になっていること
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    ## ログアウトを実施してログアウト状態になること
    delete logout_path
    assert_not is_logged_in?
    
    ## ルートURLにリダイレクトすること
    assert_redirected_to root_url
    ## 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!

    ## 画面内のリンクがログアウト後の状態になっていること
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # rememberチェックボックスONでログインした時のテスト
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end
  
  # rememberチェックボックスOFFでログインした時のテスト
  test "login without remembering" do
    ## クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    ## クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
