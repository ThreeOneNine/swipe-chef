class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.references :recipe, foreign_key: true
      t.integer :number
      t.string :description

      t.timestamps
    end
  end
end
