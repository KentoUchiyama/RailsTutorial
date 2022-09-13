require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # フォームで入力に失敗した時のテスト
  test "invalid signup information" do
    
    get signup_path

    ## ユーザが追加されないこと
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
      email: "user@invalid",
      password:              "foo",
      password_confirmation: "bar" } }
    end

    assert_template 'users/new'

    ## エラーメッセージが表示されること
    assert_select 'div[id = "error_explanation"]'
    assert_select 'div[class = "field_with_errors"]', count: 8

    ## フォームの送信先がsignupになっていること
    assert_select 'form[action="/signup"]'
  end
  
  # フォームで入力に成功した時のテスト
  test "valid signup information" do

    get signup_path

    ## ユーザが追加されること
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end

    follow_redirect!
    assert_template 'users/show'

    ## ユーザ登録成功時のメッセージが表示されること（空でないこと）
    assert_not flash.empty?
  end
end