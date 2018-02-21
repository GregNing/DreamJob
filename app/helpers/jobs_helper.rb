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
    def date_add8hour(job)
        result = job.created_at + 8.hours
        result.strftime("%Y年%m月%d日 %H:%M")
    end
end
