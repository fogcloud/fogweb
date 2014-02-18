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
end