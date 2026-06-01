class CampaignsController < ApplicationController

  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns
  end

  def create
    current_user.campaigns.create(
      name: params[:name],
      status: params[:status]
    )

    redirect_to "/campaigns/index"
  end

  def delete
    campaign = current_user.campaigns.find(params[:id])
    campaign.destroy

    redirect_to "/campaigns/index"
  end

end