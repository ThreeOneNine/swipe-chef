class UserCategoriesController < ApplicationController
  before_action :set_categories, only: %i[index]
  after_action :set_categories, only: %i[create destroy]
  after_action :index_ajax, only: %i[create destroy]

  def index
  end

  def destroy
    @user_category = UserCategory.find(params[:id])
    @category = @user_category.category
    @user_category.destroy
  end

  def create
    @user_category = UserCategory.new
    @user_category.category = Category.find(params[:category_id])
    @user_category.user = current_user
    @user_category.save
  end

  private

  def set_categories
    @categories = Category.all
    @user_categories = current_user.categories
  end

  def index_ajax
    respond_to do |f|
      f.html { redirect_to user_categories_path }
      f.js
    end
  end
end
