class CategoriesController < ApplicationController
  include TheSortableTreeController::Rebuild

  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @search = current_user.categories.search(params[:q])
    @categories = @search.result.nested_set #.select('id, name, description, parent_id, depth').all
  end

  def new
    @category = current_user.categories.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @category = current_user.categories.find(params[:id]).decorate
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @category = current_user.categories.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @category = current_user.categories.find(params[:id])
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to 'index', notice: 'Category was successfully updated.' }
        format.js { render :show }
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  def destroy
    @category.delete_node_keep_sub_nodes if params[:delete_with_sub].present?
    #@category.destroy
    #@category.valid?
    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end

  private
  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :user_id, :parent_id)
  end

end