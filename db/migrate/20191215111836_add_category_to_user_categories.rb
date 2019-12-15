class AddCategoryToUserCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_categories, :category, foreign_key: true
  end
end
