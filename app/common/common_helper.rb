module CommonHelper
    def searchs_job(params)
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