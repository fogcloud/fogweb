class MainController < ApplicationController
  before_filter :cant_be_signed_in, only: [:index]
  before_filter :must_be_signed_in, only: [:dashboard]

  def index
  end

  def dashboard
    @user = current_user
    @plan = current_user.plan

    lb = Block.order(:created_at).last
    @last = lb.nil? ? "" : lb.created_at
  end

  def contact
  end
end
