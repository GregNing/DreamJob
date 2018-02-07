class JobsController < ApplicationController
    before_action :find_jobs_id, only: [:edit, :update, :destroy, :show]
    before_action :authenticate_user!, except: [:index]
    def index
        @jobs = case params[:order]                                 
                when "descbywage_upper_bound"
                Job.all.ishidden.desc_by_wage_upper_bound.page(params[:page]).per(10)                
                when "descbywage_lower_bound"
                Job.all.ishidden.desc_by_wage_lower_bound.page(params[:page]).per(10)                
                else
                Job.all.ishidden.desc_by_created.page(params[:page]).per(10)
                end        
    end
    def show       
        not_allow_view_hidden_jobs(@job)
    end
    def new
        @job = Job.new
    end
    def create
        @job = Job.new(jobs_params)
        @job.user = current_user
        if @job.save
            redirect_to root_path, notice: "新增#{@job.title}成功"
        else
            render :new
        end
    end
    def edit
        not_allow_view_hidden_jobs(@job)
    end
    def update
        if @job.update(jobs_params)
            redirect_to root_path, notice: "修改#{@job.title}成功"
        else
            render :edit
        end
    end
    def destroy
        not_allow_view_hidden_jobs(@job)
        @job.destroy
        redirect_back fallback_location: root_path, alert: "刪除#{@job.title}成功"
    end
    private
    def find_jobs_id
        @job = Job.find(params[:id])
    end
    def jobs_params
        params.require(:job).permit(:title, :description, :wage_upper_bound,:wage_lower_bound,:contact_email)
    end
    def not_allow_view_hidden_jobs(job)
        if job.is_hidden?
            redirect_to jobs_path, warning: "此工作已被隱藏!您無法查看!"
        end
    end
end
