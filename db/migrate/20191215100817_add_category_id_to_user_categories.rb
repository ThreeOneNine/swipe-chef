class AddCategoryIdToUserCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_categories, :categories, foreign_key: true
  end
end
