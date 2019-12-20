class UserCategoriesController < ApplicationController
  def index
    @user_category = UserCategory.new
    @user_categories = current_user.user_categories
    @remaining_categories = Category.all - @user_categories.map(&:category)
  end

  def destroy
    @user_category = UserCategory.find(params[:id])
    @user_category.destroy

    @user_category = UserCategory.new
    @user_categories = current_user.user_categories
    @remaining_categories = Category.all - @user_categories.map(&:category)
    index_ajax
  end

  def create
    @user_category = UserCategory.new
    @user_category.category = Category.find(params[:category_id])
    @user_category.user = current_user
    @user_category.save

    @user_category = UserCategory.new
    @user_categories = current_user.user_categories
    @remaining_categories = Category.all - @user_categories.map(&:category)
    index_ajax
  end

  private

  def index_ajax
    respond_to do |f|
      f.html { redirect_to user_categories_path }
      f.js
    end
  end
end
