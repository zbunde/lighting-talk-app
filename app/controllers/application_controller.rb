class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :ensure_current_user

  helper_method :current_user

  def current_user
    User.find_by(auth_token: session[:access_token])
  end

  private

  def ensure_current_user
    redirect_to root_path, notice: "Please login to see that page" unless current_user.present?
  end

  def ensure_current_talk_owner
    redirect_to root_path, notice: "You don't have permission to access that page" unless current_user.id == @lightning_talk.user_id
  end

  def require_admin
    redirect_to root_path, notice: "You don't have permission to access that page" unless current_user && current_user.admin
  end

end
