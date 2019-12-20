class UserCategoriesController < ApplicationController
  def index
    @categories = Category.all
    @user_categories = current_user.categories
    # @remaining_categories = Category.all - @user_categories.map(&:category)
  end

  def destroy
    @user_category = UserCategory.find(params[:id])
    @category = @user_category.category
    @user_category.destroy

    @categories = Category.all
    @user_categories = current_user.categories
    index_ajax
  end

  def create
    @user_category = UserCategory.new
    @user_category.category = Category.find(params[:category_id])
    @user_category.user = current_user
    @user_category.save

    @categories = Category.all
    @user_categories = current_user.categories
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
