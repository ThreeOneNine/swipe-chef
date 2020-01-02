class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.user_preferences.any?
      recipes_path
    else
      user_preferences_path
    end
  end
end
