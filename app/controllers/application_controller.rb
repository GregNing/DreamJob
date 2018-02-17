class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    add_flash_types :warning
    before_action :configure_permitted_parameters, if: :devise_controller?
   protected 
    def require_is_admin
        unless current_user.admin?
            redirect_to root_path,alert: "您尚未擁有管理者權限!"
        end            
    end
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
      devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
    end
end
