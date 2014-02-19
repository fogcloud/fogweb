class MainController < ApplicationController
  before_filter :cant_be_signed_in, only: [:index]
  before_filter :must_be_signed_in, only: [:dashboard]

  def index
  end

  def dashboard
  end

  def contact
  end
end
