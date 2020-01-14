require "application_system_test_case"

class RecipesTest < ApplicationSystemTestCase
  test "Visit index" do
    visit recipes_path
    assert_selector ".carousel-item", minimum: 1
    assert_selector ".carousel-item", maximum: 20
  end
end
