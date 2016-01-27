class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :short_desc
      t.text :full_desc
      t.integer :price
      t.timestamps null: false
    end
  end
end
