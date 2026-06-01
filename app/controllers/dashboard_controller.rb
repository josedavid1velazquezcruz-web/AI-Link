class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @total_campaigns = current_user.campaigns.count
    @active_campaigns = current_user.campaigns.where(status: "Activa").count
    @campaigns = current_user.campaigns.last(5)
  end

end