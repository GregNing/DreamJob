class Admin::JobsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_jobs_id_and_check_permission, except: [:index,:new,:create]
    before_action :require_is_admin
    layout "admin"
    def index
        @locations = Location.isshow.orderbysort
        @categorys = Category.isshow.orderbysort        
        #判斷塞選
        #公司地點
        if params[:location].present?
            @location = params[:location]
            @location_id = Location.find_by(name: @location)

            if @location == "所有城市"
                @jobs = Job.where(user: current_user).desc_by_created.page(params[:page]).per(10)
            else
                @jobs = Job.where(user: current_user, location_id: @location_id).desc_by_created.page(params[:page]).per(10)            
            end
        #公司地點 end
        #職業類型
        elsif params[:category].present?
            @category = params[:category]
            @category_id = Category.find_by(name: @category)

            if @catrgory == "所有類型"
                @jobs = Job.where(user: current_user).desc_by_created.page(params[:page]).per(10)
            else
                @jobs = Job.where(user: current_user,category: @category_id ).desc_by_created.page(params[:page]).per(10)
            end
        #職業類型end
        elsif params[:bound].present?
            @bound = params[:bound]
            if @bound == '5k以下'
                @jobs = Job.where(user: current_user).lowerbound5.desc_by_created.page(params[:page]).per(10)
            elsif @bound == '5~10k'
                @jobs = Job.where(user: current_user).lowerbound10.desc_by_created.page(params[:page]).per(10)
            elsif @bound == '10~15k'
                @jobs = Job.where(user: current_user).lowerbound15.desc_by_created.page(params[:page]).per(10)
            elsif @bound == '15~25k'
                @jobs = Job.where(user: current_user).lowerbound25.desc_by_created.page(params[:page]).per(10)
            else
                @jobs = Job.where(user: current_user).lowerbound30.desc_by_created.page(params[:page]).per(10)
            end
        #預設全搜 但只搜尋自己所創建的工作
        else
            @jobs = Job.where(user: current_user).desc_by_created.page(params[:page]).per(10)
        end        
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
