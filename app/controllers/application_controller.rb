class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
    
  # before_action :set_current_user
  before_action :authenticate_user!
  
  # helper_method :refer_to_s3
  
  def after_sign_in_path_for(resource)
    user_indices_path(resource)
  end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  def after_sign_up_path_for(resource)
    new_user_session_path
  end
  

    
end
