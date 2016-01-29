class ChangeColumnInPostsToBigint < ActiveRecord::Migration
  def change
    change_column :posts, :phone, :bigint
  end
end
