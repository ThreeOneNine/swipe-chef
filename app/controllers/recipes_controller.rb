class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @recipes = recipes_based_on_preference || Recipe.all
    @recipes.sample(20)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def recipes_based_on_preference
    if user_signed_in? && current_user.user_preferences.any?
      user_category_arr = []
      user_preferences = current_user.user_preferences.first
      current_user.categories.each { |category| user_category_arr << category.name }
      @recipes = Recipe.where(category: user_category_arr,
                              cook_time: 0..user_preferences.max_cooking_time,
                              serves: user_preferences.cook_for_min..user_preferences.cook_for_max)
    end
  end
end
