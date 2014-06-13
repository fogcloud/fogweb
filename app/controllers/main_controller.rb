class MainController < ApplicationController
  before_filter :cant_be_signed_in, only: [:index]
  before_filter :must_be_signed_in, only: [:dashboard]
  before_filter :must_be_admin,     only: [:admin]

  def index
  end

  def dashboard
    @plan = current_user.plan
    @percent = sprintf("%.02f", 
      100 * current_user.megs_used.to_f / current_user.plan.megs) 
  end

  def contact
  end

  def admin
  end
end
