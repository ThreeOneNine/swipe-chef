require "application_system_test_case"

class UserPreferencesTest < ApplicationSystemTestCase
  test "Lets a signed in user create a new user preference" do
   login_as users(:user_1)
   visit user_preferences_path
   save_and_open_screenshot

   fill_in "Maximum cooking time", with: 50
   fill_in "Minimum servings", with: 2
   fill_in "Maximum servings", with: 5
   save_and_open_screenshot

   click_on 'Set Preference'
   save_and_open_screenshot

   # Check recipe matches new preferences
   visit recipes_path


 end
end

# # Should be redirected to recipes index
# assert_equal recipes_path, page.current_path
