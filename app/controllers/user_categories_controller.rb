class UserCategoriesController < ApplicationController
  def index
    set_categories
  end

  def destroy
    @user_category = UserCategory.find(params[:id])
    @user_category.destroy
    set_categories
    index_ajax
  end

  def create
    @user_category = UserCategory.new
    @user_category.category = Category.find(params[:category_id])
    @user_category.user = current_user
    @user_category.save
    set_categories
    index_ajax
  end

  def toggle_all
    set_categories
    if @user_categories.length == @categories.length
      current_user.user_categories.each(&:destroy)
    else
      @categories.each do |category|
        unless @user_categories.include?(category)
          UserCategory.create(category: category, user: current_user)
        end
      end
    end
    set_categories
    index_ajax
  end

  private

  def set_categories
    @categories = Category.all
    # @user_categories = current_user.categories
    @user_categories = UserCategory.where(user: current_user).map(&:category)
  end

  def index_ajax
    respond_to do |f|
      f.html { redirect_to user_categories_path }
      f.js
    end
  end
end
