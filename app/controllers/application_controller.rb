class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  before_action :devise_permitted_params, if: :devise_controller?

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
    if request.headers['X-FogSync-Auth']
      user = User.find_by_auth_key(request.headers['X-FogSync-Auth'])
      if user
        sign_in user
      else
        force_json_response
        respond_to do |format|
          format.json { render status: 401, json: { error: "Invalid authentication key" } }
        end
      end
    end

    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: "Please log in first." }
        format.json { render status: 401, json: { error: "Must be logged in" } }
      end
    end
  end

  def cant_be_signed_in
    if user_signed_in?
      redirect_to main_dashboard_path
    end 
  end

  def force_json_response
    request.format = "json"
  end

  def devise_permitted_params
    devise_parameter_sanitizer.for(:sign_up) << :invite_code
  end
end
