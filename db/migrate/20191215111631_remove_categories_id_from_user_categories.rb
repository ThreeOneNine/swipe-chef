class RemoveCategoriesIdFromUserCategories < ActiveRecord::Migration[5.2]
  def change
    remove_reference :user_categories, :categories, foreign_key: true
  end
end
