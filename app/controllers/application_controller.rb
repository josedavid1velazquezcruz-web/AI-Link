class ApplicationController < ActionController::Base

  def after_confirmation_path_for(resource_name, resource)
    root_path
  end

  def after_sign_in_path_for(resource)
    "/dashboard/index"
  end

  def after_sign_up_path_for(resource)
    root_path
  end

end