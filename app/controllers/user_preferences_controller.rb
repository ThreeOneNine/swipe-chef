class UserPreferencesController < ApplicationController
  def index
    if current_user.user_preferences.any?
      @user_preference = current_user.user_preferences.first
    else
      @user_preference = UserPreference.new
    end
  end

  def update
    @user_preference = current_user.user_preferences.first
    @user_preference.update!(strong_params)
    redirect_to recipes_path
  end

  def create
    @user_preference = UserPreference.new(strong_params)
    @user_preference.user = current_user
    @user_preference.save
    index_ajax
  end

  private

  def strong_params
    params.require(:user_preference).permit(:max_cooking_time, :cook_for_min, :cook_for_max)
  end

  def index_ajax
    respond_to do |f|
      f.html { redirect_to user_preferences_path }
      f.js
    end
  end
end
