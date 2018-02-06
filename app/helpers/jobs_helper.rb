module JobsHelper
    def render_jobs_description(job)
        simple_format(job.description)
    end
end
