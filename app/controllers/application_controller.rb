class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    add_flash_types :warning    
   protected 
    def require_is_admin
        unless current_user.admin?
            redirect_to root_path,alert: "您無權限進行此操作!"
        end            
    end
    def require_is_dreamjob_admin
        unless current_user.dreamjob_admin?
            redirect_to root_path,alert: "您無權限進行此操作!"
        end            
    end
end
