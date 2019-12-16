class UserPreferencesController < ApplicationController
  before_action :set_user_preference, only: [:index, :update]

  def index
  end

  def update
    @user_preference.update(strong_params)
    render :index
  end

  private

  def set_user_preference
    @user_preference = UserPreference.where(user: current_user).first
  end

  def strong_params
    params.require(:user_preference).permit(:max_cooking_time, :cook_for_min, :cook_for_max)
  end
end
