class Days::LightningTalksController < ApplicationController
  before_action :set_day

  def new
    @lightning_talk = LightningTalk.new
  end

  def create
    lightning_talk = @day.lightning_talks.new(lightning_talk_params.merge(user_id: current_user.id))
    lightning_talk, success = LightningTalkManager.build(lightning_talk)
    if lightning_talk.save
      redirect_to root_path, notice: "Thanks for signing up for a lightning talk!"
    else
      @lightning_talk = LightningTalk.new
      flash[:notice] = "Something went wrong"
      render :new
    end
  end

  def index
    @lightning_talks = @day.lightning_talks
  end

  private

  def lightning_talk_params
    params.require(:lightning_talk).permit(:name, :day_id)
  end

  def set_day
    @day = Day.find(params[:day_id])
  end
end
