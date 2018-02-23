class Account::CollectionsController < ApplicationController
    before_action :authenticate_user!
    def index
        @collections = Collection.where(user: current_user).order("created_at DESC").page(params[:page]).per(8)
        @recommand = Job.random5
    end
end
