class Admin::ResumesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_is_admin
    layout "admin"
    def index        
            path = "/#{redocument.redocument}"
            send_file path, :x_sendfile=>true
        @job = Job.find(params[:job_id])
        @resumes = @job.resumes.order("created_at DESC")  
    end

    def show
        @resume = Resume.find(params[:id])
    end
end
