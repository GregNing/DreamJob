module ResumesHelper
    def date_add8hour(resume)
        result = resume.created_at + 8.hours
        result.strftime("%Y年%m月%d日 %H:%M")
    end
end
