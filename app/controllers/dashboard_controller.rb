class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_campaigns = current_user.campaigns.count
    @active_campaigns = current_user.campaigns.where(status: "Activa").count
    @total_products = current_user.products.count
    @total_stock = current_user.products.sum(:quantity)
    @low_stock = current_user.products.where("quantity <= ? AND quantity > ?", 5, 0).count
    @recent_campaigns = current_user.campaigns.order(created_at: :desc).limit(3)
    @recent_products = current_user.products.order(created_at: :desc).limit(3)
  end
end