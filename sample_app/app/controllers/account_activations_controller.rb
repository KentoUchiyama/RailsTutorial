class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # "!user.activated?"で既に有効になっているユーザーを再度有効化できないようにしている（有効化リンクの悪用対策）
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end