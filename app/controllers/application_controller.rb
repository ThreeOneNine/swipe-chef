class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if UserPreference.where(user: current_user).any?
      recipes_path
    else
      user_preferences_path
    end
  end
end
