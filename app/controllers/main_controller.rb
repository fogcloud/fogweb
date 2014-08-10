require 'secrets'

class MainController < ApplicationController
  before_filter :cant_be_signed_in, only: [:index]
  before_filter :must_be_signed_in, only: [:dashboard]
  before_filter :must_be_admin,     only: [:admin]
  before_filter :respond_with_json, only: [:auth]

  def index
  end

  def dashboard
    @plan = current_user.plan
    @store_percent = sprintf("%.02f", 
      100 * current_user.megs_used.to_f / current_user.plan.megs)
    @trans_percent = sprintf("%.02f", 
      100 * current_user.megs_trans.to_f / (2 * current_user.plan.megs))
  end

  def contact
  end

  def admin
    @invite_code = Secrets.get_hex('invite_code', 4)
  end

  def auth
    unless params[:email] and params[:password]
      render text: "Requires email and password", status: 500
      return
    end

    @user = User.find_by_email(params[:email])
    if @user.nil? || !@user.valid_password?(params[:password])
      render text: "Authentication failed", status: 401
      return
    end
  end

  private

  def respond_with_json
    request.format = :json
  end
end
