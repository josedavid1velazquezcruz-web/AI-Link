class CampaignsController < ApplicationController
  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns.order(created_at: :desc)
  end

  def create
    current_user.campaigns.create(
      name: params[:name],
      status: params[:status].presence || "Activa"
    )

    redirect_to campaigns_index_path
  end

  def delete
    campaign = current_user.campaigns.find(params[:id])
    campaign.destroy

    redirect_to campaigns_index_path
  end
end