module ResumesHelper
    def resume_date_add8hour(resume)
        result = resume.created_at + 8.hours
        result.strftime("%Y年%m月%d日 %T")
    end
end
