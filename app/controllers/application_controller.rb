class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def show_notice(msg)
    flash[:notice] ||= []
    flash[:notice] << msg
  end

  def show_alert(msg)
    flash[:alert] ||= []
    flash[:alert] << msg
  end

  def must_be_admin
    unless current_user.admin?
      redirect_to main_dashboard_path, notice: "Permission denied"
    end
  end

  def must_be_signed_in
    unless user_signed_in?
      redirect_to new_user_session_path, notice: "Please log in first."
    end
  end

  def cant_be_signed_in
    if user_signed_in?
      redirect_to main_dashboard_path
    end 
  end
end
