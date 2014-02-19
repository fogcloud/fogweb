class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def create  
    respond_to do |format|  
      format.html do
        super
      end
      format.json do
        warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")  
        render status: 200, json: { msg: "Logged in as #{current_user.email}" }  
      end
    end  
  end
end
