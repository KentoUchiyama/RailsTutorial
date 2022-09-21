require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # homeページ表示の確認
  test "should get home" do

    ## homeページが表示されること
    get root_path
    assert_response :success

    ## タイトルの表示が正しいこと
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  # helpページ表示の確認
  test "should get help" do

    ## helpページが表示されること
    get help_path
    assert_response :success

    ## タイトルの表示が正しいこと
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  # aboutページ表示の確認
  test "should get about" do

    ## aboutページが表示されること
    get about_path
    assert_response :success

    ## タイトルの表示が正しいこと
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end

  # contactページ表示の確認
  test "should get contact" do
    
    ## contactページが表示されること
    get contact_path
    assert_response :success

    ## タイトルの表示が正しいこと
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end
end