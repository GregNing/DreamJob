module Admin::JobsHelper
    def ishiddenhelper(job)    
        if job.is_hidden?
       content_tag(:span, "", class: "fa fa-lock")  
        else
        content_tag(:span, "" ,class: "fa fa-globe")
        end    
                
    end    
end
