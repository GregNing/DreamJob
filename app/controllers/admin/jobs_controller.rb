class Admin::JobsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_jos_id, except: [:index,:new,:create]
    before_action :require_is_admin
    def index
        @jobs = Job.all.desc_by_created.page(params[:page]).per(10)
    end
    def show
        
    end
    def new
        @job = Job.new
    end
    def create
        @job = Job.new(jobs_params)
        @job.user = current_user
        if @job.save
            redirect_to admin_jobs_path,notice: "新增#{@job.title}成功!"
        else
            render :new
        end
    end
    def edit
        
    end
    def update
        if @job.update(jobs_params)
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
          redirect_to admin_jobs_path ,notice: "#{@job.title}發布成功!"
        else            
        redirect_to admin_jobs_path ,alert: "已經隱藏!"
        end        
    end
    def hide        
        if @job.is_hidden?
            redirect_to admin_jobs_path ,alert: "已經發布!"
        else            
            @job.hide!
            redirect_to admin_jobs_path, warning: "#{@job.title}隱藏成功!"
        end
    end
    private
    def find_jos_id
        @job = Job.find(params[:id])
    end
    def jobs_params
        params.require(:job).permit(:title,:description,:wage_upper_bound,
        :wage_lower_bound,:contact_email, :is_hidden)
    end
end
