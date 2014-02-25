class MainController < ApplicationController
  before_filter :cant_be_signed_in, only: [:index]
  before_filter :must_be_signed_in, only: [:dashboard]

  def index
  end

  def dashboard
    @user = current_user
    @plan = current_user.plan
    @last = Block.order(:created_at).last.created_at
  end

  def contact
  end
end
