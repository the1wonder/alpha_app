class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :show, :update]
  before_action :require_admin, except:[:index, :show]

  def index
      @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
  end

  def create
      @category = Category.new(category_params)
      if @category.save
        flash[:success] = "You have successfully create new Category"
        redirect_to categories_path
      else
        render 'new'
      end
  end

  def edit

  end

  def update
      if @category.update(category_params)
        flash[:success] = "your category successfully updated"
        redirect_to categories_path
        else
          render 'edit'
      end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = "your categroy successfully deletet"
    redirect_to categories_path
  end

  def show
    @category = Category.find(params[:id])
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? ||(logged_in? and !current_user.admin?)
       flash[:danger] = "only admin can perform this action"
       redirect_to articles_path
    end
  end

end
