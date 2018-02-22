class Admin::JobsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_jobs_id_and_check_permission, except: [:index,:new,:create]
    before_action :require_is_admin
    layout "admin"

    def index        
        @locations = Location.isshow.orderbysort
        @categorys = Category.isshow.orderbysort        
        @jobs = helpers.searchs_jobs(params)             
    end
    def show        
    end
    def new
        @job = Job.new    
    end
    def create
        @job = Job.new(job_params)
        @job.user = current_user
        if @job.save
            redirect_to admin_jobs_path,notice: "新增#{@job.title}成功!"
        else
            render :new
        end
    end
    def edit
        @categorys = Category.isshow.orderbysort
        @locations = Location.isshow.orderbysort
    end
    def update
        if @job.update(job_params)
            redirect_to admin_jobs_path,notice: "修改#{@job.title}成功!"
        else
            render :edit
        end
    end
    def destroy
        @job.destroy
        redirect_to admin_jobs_path, alert: "刪除#{@Job.title}成功！"        
    end
    def publish
        if @job.is_hidden?          
            @job.publish!            
            redirect_back fallback_location: root_path, notice: "發布 #{@job.title}成功"
        else            
            redirect_back fallback_location: root_path,alert: "已經發布!"            
        end        
    end
    def hide        
        if @job.is_hidden?            
            redirect_back fallback_location: root_path,alert: "已經隱藏!" 
        else            
            @job.hide!            
            redirect_back fallback_location: root_path, notice: "隱藏 #{@job.title}成功"
        end
    end
    private
    def find_jobs_id_and_check_permission
        @job = Job.find(params[:id])

        if @job.user != current_user
            redirect_to root_path, alert: "您沒有權限進行此操作。"
        end
    end
    def job_params
        params.require(:job).permit(:title, :description, :company, :category_id, :location_id,
        :wage_upper_bound, :wage_lower_bound,:contact_email, :is_hidden)
    end

end
