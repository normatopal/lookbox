class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :edit, :update, :destroy, :available_pictures, :add_pictures]

  def index
    @search = current_user.categories.nested_set.search(params[:q])
    @categories = @search.result #.select('id, name, description, parent_id, depth').all
  end

  def new
    @category = current_user.categories.new.decorate
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @category = current_user.categories.new(category_params).decorate
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
        format.js { render :show }
      else
        format.html { render :edit }
        format.js { render :edit }
      end
    end
  end

  def destroy
    @category.move_subcategories unless params[:delete_with_sub].present?
    @category.destroy
    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end

  def available_pictures
    @available_pictures = current_user.pictures.available_for_category(params[:id])
  end

  def add_pictures
    @category.pictures << current_user.pictures.where("id in (?)", category_params[:picture_ids])
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id]).decorate
  end

  def category_params
    params.require(:category).permit(:name, :description, :user_id, :parent_id, picture_ids: [])
  end

end