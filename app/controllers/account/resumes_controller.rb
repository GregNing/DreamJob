class Account::ResumesController < ApplicationController
    before_action :authenticate_user!
    def index
        @resumes = Resume.where(user: current_user).order("created_at DESC").page(params[:page]).per(8)
        @recommand = Job.random5
    end
end
