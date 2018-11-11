class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end
  
  def after_sign_in_path_for(resource)
   
    user_indices_path(6)
  end
end
