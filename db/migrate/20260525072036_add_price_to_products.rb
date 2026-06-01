class AddPriceToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :price, :decimal
  end
end
