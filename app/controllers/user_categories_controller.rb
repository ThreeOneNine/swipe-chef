class UserCategoriesController < ApplicationController
  before_action :set_categories, only: %i[index]

  def index
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
    if @user_categories == @categories
      current_user.user_categories.each(&:destroy)
    else
      @categories.map do |category|
        unless @user_categories.include?(category)
          uc = UserCategory.new
          uc.category = category
          uc.user = current_user
          uc.save
        end
      end
    end
    index_ajax
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
