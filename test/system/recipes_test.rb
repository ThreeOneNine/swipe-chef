require "application_system_test_case"

class RecipesTest < ApplicationSystemTestCase
  test "Visit index" do
    visit recipes_path
    assert_selector "div", class: "carousel-item"
  end
end
