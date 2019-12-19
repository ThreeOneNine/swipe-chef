class UserCategoriesController < ApplicationController
  def index
    @user_categories = UserCategories.where(user: current_user)
  end
end
