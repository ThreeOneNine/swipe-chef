require "application_system_test_case"

class UserPreferencesTest < ApplicationSystemTestCase
  test "Lets a signed in user create a new user preference" do
    login_as users(:user_1)
    visit user_preferences_path

    fill_in "Maximum cooking time", with: 50
    fill_in "Minimum servings", with: 2
    fill_in "Maximum servings", with: 2
    click_on 'Set Preference'

    # Check relocation to recipe index and recipe matches new preference
    assert_equal recipes_path, page.current_path
    assert_selector "#recipe_serves", text: "2 people"
  end

  test "Serving min max validation" do
    login_as users(:user_1)
    visit user_preferences_path

    fill_in "Maximum cooking time", with: 50
    fill_in "Minimum servings", with: 4
    fill_in "Maximum servings", with: 3
    click_on 'Set Preference'

    # Should stay on same page
    assert_equal user_preferences_path, page.current_path

    # Should load error message
    assert_selector "div.invalid-feedback", count: 1
  end
end
