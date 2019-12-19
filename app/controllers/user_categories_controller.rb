class UserCategoriesController < ApplicationController
  def index
    @user_categories = current_user.categories
    @remaining_categories = Category.all - @user_categories
  end
end
