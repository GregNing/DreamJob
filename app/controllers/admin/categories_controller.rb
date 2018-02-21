class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_dreamjob_admin
  before_action :find_category_id, except: [:index, :new , :create]
  layout "admin"
    def index
        @categorys = Category.all.orderbysort
    end

    def new
        @category = Category.new
    end
    def create
        @category = Category.new(category_params)
        @category.sort = Category.descbysort.count == 0 ? 1 : Category.descbysort.first.sort + 1        
        if @category.save      
            redirect_to admin_categories_path, notice: "#{@category.name}職位新增成功"
        else
            render :new
        end
    end
    def edit      
    end
    def update
        if  @category.update(category_params)
            redirect_to admin_categories_path, notice: "#{@category.name}職位修改成功"
        else
            render :edit
        end    
    end

    def publish
        if @category.is_hidden?          
            @category.publish!      
            redirect_back fallback_location: root_path, notice: "發布 #{@category.name}成功"
        else                        
            redirect_back fallback_location: root_path, alert: "#{@category.name} 已經發布!"
        end 
    end
    def hide
        if @category.is_hidden?          
            redirect_back fallback_location: root_path, alert: "#{@category.name} 已經隱藏!"
        else                                    
            @category.hide!      
            redirect_back fallback_location: root_path, notice: "隱藏 #{@category.name}成功"
        end       
    end

    #往上排序 此工作排序 -1
    def up      
      @categoryoriginal = Category.find_by(sort: @category.sort - 1)      
      @category.sort -= 1

      #排序數字 大於0才存檔
      if @category.sort > 0
        @category.save
      end
      
      #將要被排序的位置調換
      if @categoryoriginal.present?
        @categoryoriginal.sort += 1
        @categoryoriginal.save
      end

      redirect_back fallback_location: root_path
    end
    
    #+1做排序動作
    def down      
      @categoryoriginal = Category.find_by(:sort => @category.sort + 1)
      @category.sort += 1
      @category.save

      #將要被排序的位置調換
      if @categoryoriginal.present?
        @categoryoriginal.sort -= 1
        @categoryoriginal.save
      end

      redirect_back fallback_location: root_path
    end

    private

    def find_category_id
        @category = Category.find(params[:id])
    end
    def category_params
        params.require(:category).permit(:name, :icon, :is_hidden)
    end
end
