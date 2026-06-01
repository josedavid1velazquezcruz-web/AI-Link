class ProfileController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def update
    current_user.update(username: params[:username])

    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
    end

    redirect_to "/profile/index"
  end

end