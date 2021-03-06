class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :require_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def require_user
    return if logged_in?
    flash[:danger] = 'You must be logged in to perform this action'
    redirect_to root_path
  end

  def require_admin
    return if current_user.admin?    
    flash[:danger] = "Only admin users can perform this action"
    redirect_to root_path
  end
end
