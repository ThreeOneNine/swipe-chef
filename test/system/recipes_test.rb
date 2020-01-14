require "application_system_test_case"

class RecipesTest < ApplicationSystemTestCase
  test "At least 1 recipe displayed on carousel" do
    visit recipes_path
    assert_selector "div", class: "carousel-item"
  end
end
