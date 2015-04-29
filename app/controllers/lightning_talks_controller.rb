class LightningTalksController < ApplicationController
  before_action :set_user

  def index
    @lightning_talks = LightningTalk.all
  end
end
