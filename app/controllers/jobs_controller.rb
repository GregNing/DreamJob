class JobsController < ApplicationController
    before_action :find_jobs_id, only: [:edit, :update, :destroy, :show]
    before_action :authenticate_user!, except: [:index]
    def index
        @jobs = Job.all.ishidden.desc_by_created.page(params[:page]).per(10)
    end
    def show       
    end
    def new
        @job = Job.new
    end
    def create
        @job = Job.new(jobs_params)
        if @job.save
            redirect_to root_path, notice: "新增#{@job.title}成功"
        else
            render :new
        end
    end
    def edit
        
    end
    def update
        if @job.update(jobs_params)
            redirect_to root_path, notice: "修改#{@job.title}成功"
        else
            render :edit
        end
    end
    def destroy
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
end
