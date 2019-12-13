class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :img_url
      t.string :description
      t.integer :prep_time
      t.integer :cook_time
      t.integer :serves
      t.string :difficulty
      t.integer :ingredients_count
      t.string :category
      t.string :video_url

      t.timestamps
    end
  end
end
