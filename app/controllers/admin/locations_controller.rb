class Admin::LocationsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_is_dreamjob_admin
    before_action :find_by_locations_id, except: [:index ,:new, :create]
    layout "admin"
    def index
        @locations = Location.all.orderbysort
    end
    def new
        @location = Location.new
    end
    def create
        @location = Location.new(location_params)
        @location.sort = Location.descbysort.count == 0 ? 1 : Location.descbysort.first.sort + 1
        if @location.save
            redirect_to admin_locations_path,notice: "新增#{@location.name}成功"
        else
            render :new
        end
    end
    def edit        
    end
    def update
        if @location.update(location_params)
            redirect_to admin_locations_path,notice: "修改#{@location.name}成功"
        else
            render :edit
        end
    end
    def publish
        if @location.is_hidden?          
            @location.publish!
            redirect_back fallback_location: root_path, notice: "發布 #{@location.name}成功"
        else            
            redirect_back fallback_location: root_path,alert: "#{@location.name} 已經隱藏!"
        end                   
    end

    def hide
        if @location.is_hidden?          
            redirect_back fallback_location: root_path,alert: "#{@location.name} 已經發布!"
        else            
            @location.hide!
            redirect_back fallback_location: root_path, notice: "隱藏 #{@location.name}成功" 
        end                
    end
    def up
    @locationoriginal = Location.find_by(sort: @location.sort - 1)
    @location.sort -= 1
    
    if @location.sort > 0
      @location.save
    end
    #將要被排序的位置調換
    if @locationoriginal.present?
      @locationoriginal.sort += 1
      @locationoriginal.save
    end
        redirect_back fallback_location: root_path
    end
    def down    
        @locationoriginal = Location.find_by(:sort => @location.sort + 1)
        @location.sort += 1
        @location.save
            #將要被排序的位置調換
        if @locationoriginal.present?
            @locationoriginal.sort -= 1
            @locationoriginal.save
        end
        redirect_back fallback_location: root_path
    end
    private
    def location_params
        params.require(:location).permit(:name,:is_hidden)
    end
    def find_by_locations_id
        @location = Location.find(params[:id])
    end
end
