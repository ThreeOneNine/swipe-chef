class CreateUserPreferences < ActiveRecord::Migration[5.2]
  def change
    create_table :user_preferences do |t|
      t.references :user, foreign_key: true
      t.integer :max_cooking_time
      t.integer :cook_for_min
      t.integer :cook_for_max

      t.timestamps
    end
  end
end
