class InventoryController < ApplicationController

  before_action :authenticate_user!

  def index
    @products = current_user.products
    @total_products = @products.count
    @total_stock = @products.sum(:quantity)
    @low_stock = @products.where("quantity <= ?", 5).count
  end

  def sold
    product = current_user.products.find(params[:product_id])
    sold_quantity = params[:sold_quantity].to_i

    if sold_quantity > 0
      product.quantity = product.quantity - sold_quantity
      product.quantity = 0 if product.quantity < 0
      product.save
    end

    redirect_to "/inventory/index"
  end

  def sold_out
    product = current_user.products.find(params[:product_id])
    product.update(quantity: 0)

    redirect_to "/inventory/index"
  end
def delete
  product = current_user.products.find(params[:product_id])
  product.destroy

  redirect_to "/inventory/index"
end
end