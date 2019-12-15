class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index,:show]

  def index
    if user_signed_in?
      @recipes = recipes_based_on_preference
    else
      @recipes = Recipe.all.shuffle.sample(20)
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def recipes_based_on_preference
    if current_user.user_preferences != []
      user_category_arr = []
      current_user.categories.each { |category| user_category_arr << category.name}
      @recipes = Recipe.where(category: user_category_arr,
                  cook_time: 0..current_user.user_preferences.first.max_cooking_time,
                  serves: current_user.user_preferences.first.cook_for_min..current_user.user_preferences.first.cook_for_max).shuffle.sample(20)
    else
      Recipe.all.shuffle.sample(20)
    end
  end
end
