module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember # ユーザの永続化情報をDBに保存
    # 署名付きCookieで保存(.signedの部分、permanentは有効期限を永続化する指定)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  ## session[:user_id]が存在すれば一時セッションからユーザーを取り出し、
  ## それ以外の場合はcookies[:user_id]からユーザーを取り出す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # 永続的セッションを破棄する
  def forget(user)
    ## DBのトークンを削除
    user.forget
    ## Cookieを削除
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    ## URLを削除しないと次回ログインしたときに保護されたページに転送されてしまう
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく（GETリクエストのみ記憶する）
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end