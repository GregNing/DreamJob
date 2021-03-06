module JobsHelper
    #工作隱藏顯示圖示
    def render_job_status(job)    
        if job.is_hidden?
            "fa fa-lock"
        #content_tag(:span, "", class: "fa fa-lock")
        else
        #content_tag(:span, "" ,class: "fa fa-globe")
        "fa fa-globe"
        end                    
    end
    #工作內容
    def render_jobs_description(job)
        simple_format(job.description)
    end
    #薪水區間
    def render_job_bound(job)
        "#{job.wage_lower_bound} k ~ #{job.wage_upper_bound} k"
    end
    # 是否投遞過履歷icon
    def render_job_resumes(job)
        if job.resumes.count > 0
        "fa fa-envelope-open-o"
        else
        "fa fa-envelope-o"
        end
    end
    #收藏icon
    def render_job_collections(job)
        if job.collections.count > 0
        "fa fa-heart"
        else
        "fa fa-heart-o"
        end
    end
    #是否隱藏該職缺
    def render_job_hidden(job)
        if job.is_hidden
        "hidden-box"
        end
    end
    #UTC + 8小時
    def date_add8hour(job)
        result = job.created_at + 8.hours
        result.strftime("%Y年%m月%d日 %H:%M")
    end
    def searchs_jobs(params)
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
end
