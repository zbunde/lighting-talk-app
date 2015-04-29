class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @lightning_talks = LightningTalk.all
    @users = User.all
  end

end
