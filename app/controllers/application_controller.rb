class ApplicationController < ActionController::Base
  protect_from_forgery

#  before_filter :authenticate_user!

  def load_group_from_params
    @group = Group.find(params[:group_id])
  end
end
