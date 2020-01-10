class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show next_step previous_step]

  def index
    @recipes = recipes_based_on_preference || Recipe.all
    @recipes = @recipes.sample(20)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @step = 1
  end

  def previous_step
    @recipe = Recipe.find(params[:id])
    @step = params[:step].to_i
    @step == 1 ? @step = @recipe.steps.count : @step -= 1
    step_ajax
  end

  def next_step
    @recipe = Recipe.find(params[:id])
    @step = params[:step].to_i
    @step == @recipe.steps.count ? @step = 1 : @step += 1
    step_ajax
  end

  private

  def recipes_based_on_preference
    if user_signed_in? && current_user.user_preferences.any? && current_user.categories.any?
      user_category_arr = []
      user_preferences = current_user.user_preferences.first
      current_user.categories.each { |category| user_category_arr << category.name }
      @recipes = Recipe.where(category: user_category_arr,
                              cook_time: 0..user_preferences.max_cooking_time,
                              serves: user_preferences.cook_for_min..user_preferences.cook_for_max)
    end
  end

  def step_ajax
    respond_to do |f|
      f.html { redirect_to recipe_path(@recipe) }
      f.js
    end
  end
end
