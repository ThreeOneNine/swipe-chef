class UserPreferencesController < ApplicationController
  def index
    if UserPreference.where(user: current_user).any?
      @user_preference = UserPreference.where(user: current_user).first
    else
      @user_preference = UserPreference.new
    end
  end

  def update
    @user_preference = UserPreference.where(user: current_user).first
    @user_preference.update(strong_params)
    render :index
  end

  def create
    @user_preference = UserPreference.new(strong_params)
    @user_preference.user = current_user
    @user_preference.save
    render :index
  end

  private

  def strong_params
    params.require(:user_preference).permit(:max_cooking_time, :cook_for_min, :cook_for_max)
  end
end
