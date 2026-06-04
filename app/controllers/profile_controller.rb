class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_campaigns = current_user.campaigns.count
    @total_products = current_user.products.count
    @total_stock = current_user.products.sum(:quantity)
  end

  def update
    current_user.update(
      username: params[:username]
    )

    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
    end

    redirect_to profile_index_path
  end
end