class AddNewToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_new, :boolean
  end
end
