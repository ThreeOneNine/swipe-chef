class UserPreferencesController < ApplicationController
  def index
    @user_preferences = UserPreference.where(user: current_user)
  end
end
