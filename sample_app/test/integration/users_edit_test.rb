require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # ユーザ編集失敗のテスト
  test "unsuccessful edit" do

    ## ユーザ編集はログインが必要なためログインを実施
    log_in_as(@user)

    ## ユーザ編集画面が表示されること
    get edit_user_path(@user)
    assert_template 'users/edit'

    ## 無効なユーザ情報を送信したときにユーザ編集画面が再描画されること
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'

    ## エラーメッセージの数が正しいこと
    assert_select "div[class=?]", 'alert alert-danger', text: "The form contains 4 errors."
  end

  # ユーザ編集成功時のテスト
  test "successful edit with friendly forwarding" do

    ## ログアウト状態で編集画面を表示
    get edit_user_path(@user)
    
    ## ログインして編集画面にリダイレクトされること(記憶したURLも消えていること)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url]

    ## 有効な情報を送信したときにflashメッセージありのプロフィール画面が表示されること
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user

    ## 送信した情報がDBに反映されていること
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end