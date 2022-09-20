require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  # フォームで入力に失敗した時のテスト
  test "invalid signup information" do
    
    ## ユーザが追加されないこと
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
      email: "user@invalid",
      password:              "foo",
      password_confirmation: "bar" } }
    end

    ## エラーメッセージが表示されること
    assert_template 'users/new'
    assert_select 'div[id = "error_explanation"]'
    assert_select 'div[class = "field_with_errors"]', count: 8

    ## フォームの送信先がsignupになっていること
    assert_select 'form[action="/signup"]'
  end
  
  # フォームで入力に成功した時のテスト
  test "valid signup information with account activation" do

    
    ## ユーザが追加されること
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 2, ActionMailer::Base.deliveries.size
    user = assigns(:user)   # Usersコントローラのcreateアクションで定義している@userにアクセス
    assert_not user.activated?
    ## 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    ## 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    ## トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    ## 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end