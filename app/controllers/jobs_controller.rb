class JobsController < ApplicationController
    before_action :find_jobs_id, only: [:edit, :update, :destroy, :show]
    before_action :authenticate_user!, except: [:index]
    before_action :validates_search_key, only: [:search]
    def index
        @locations = Location.isshow.orderbysort
        @categorys = Category.isshow.orderbysort
        @recommand = Job.random5
        #判斷塞選
        #公司地點
        if params[:location].present?
            @location = params[:location]
            @location_id = Location.find_by(name: @location)
            if @location == "所有城市"
                @jobs = Job.where(user: current_user).isshow.desc_by_created.page(params[:page]).per(8)
            else
                @jobs = Job.where(user: current_user, location_id: @location_id).isshow.desc_by_created.page(params[:page]).per(8)            
            end
        #公司地點 end
        #職業類型
        elsif params[:category].present?
            @category = params[:category]
            @category_id = Category.find_by(name: @category)
            if @catrgory == "所有類型"
                @jobs = Job.where(user: current_user).isshow.desc_by_created.page(params[:page]).per(8)
            else
                @jobs = Job.where(user: current_user,category: @category_id ).isshow.desc_by_created.page(params[:page]).per(8)
            end
        #職業類型end
        elsif params[:bound].present?
            @bound = params[:bound]
            if @bound == '5k以下'
                @jobs = Job.where(user: current_user).isshow.lowerbound5.desc_by_created.page(params[:page]).per(8)
            elsif @bound == '5~10k'
                @jobs = Job.where(user: current_user).isshow.lowerbound10.desc_by_created.page(params[:page]).per(8)
            elsif @bound == '10~15k'
                @jobs = Job.where(user: current_user).isshow.lowerbound15.desc_by_created.page(params[:page]).per(8)
            elsif @bound == '15~25k'
                @jobs = Job.where(user: current_user).isshow.lowerbound25.desc_by_created.page(params[:page]).per(8)
            else
                @jobs = Job.where(user: current_user).isshow.lowerbound30.desc_by_created.page(params[:page]).per(8)
            end
        #預設全搜 但只搜尋自己所創建的工作
        else
            @jobs = Job.where(user: current_user).isshow.desc_by_created.page(params[:page]).per(8)
        end 
    end
    def show       
        not_allow_view_hidden_jobs(@job)
        @category = @job.category
        #扣掉當前職位以及隨機挑選5職位
        @randomjobs = Job.where(category: @job.category).where.not(id: @job.id).isshow.random5
        @resumes = Resume.where(job: @job,user: current_user)
    end
    def add
        @job = Job.find(params[:id])

        unless current_user.is_colectedmember_of?(@job)
            current_user.add_collection!(@job)    
        end

        redirect_back fallback_location: root_path, notice: "#{@job.title}儲存喜愛工作成功!"         
    end
    
    def remove
        @job = Job.find(params[:id])

        if current_user.is_colectedmember_of?(@job)
        current_user.remove_collection!(@job)
        end

        redirect_back fallback_location: root_path, warning: "#{@job.title}從喜愛工作移除成功!"
    end

    def search
        if @query_string.present?        
        #使用like 搜尋職位
        @q = Job.joins(:location).ransack(@search_criteria).result(distinct: true)
        @jobs = @q.isshow.page(params[:page]).per(10)
        #隨機推薦5個職位        
        @recommand = Job.random5
        end
    end   
    private
    def validates_search_key
        # 去除特殊字符 #
        @query_string = params[:keyword].gsub(/\\|\'|\/|\?/, "") if params[:keyword].present?
        @search_criteria = search_criteria(@query_string)
    end
    
    def search_criteria(query_string)
        #塞選多欄位
        { title_or_company_or_location_name_cont: query_string }
    end

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
