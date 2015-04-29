class Users::LightningTalksController < ApplicationController
  before_action :set_user

  def index
    @lightning_talks = @user.lightning_talks
  end

  def new
    @lightning_talk = LightningTalk.new
    @days = Day.where("talk_date >=?", Date.today).sort_by { |d| d.talk_date}
  end

  def show
    @lighting_talk = LightningTalk.find(params[:id])
  end

  def create
    lightning_talk = @user.lightning_talks.new(lightning_talk_params)
    lightning_talk, success = LightningTalkManager.build(lightning_talk)
    @days = Day.where("talk_date >=?", Date.today).sort_by { |d| d.talk_date}
    if lightning_talk.save
      flash[:notice] = "Thanks for signing up for a lightning talk!"
      redirect_to root_path
    else
      flash[:notice] = "Somethign went wrong"
      @lightning_talk = LightningTalk.new
      render :new
    end
  end

  def edit
    @lightning_talk = LightningTalk.find(params[:id])
    ensure_current_talk_owner
    @days = Day.where("talk_date >=?", Date.today).sort_by { |d| d.talk_date }
  end

  def update
    lightning_talk = @user.lightning_talks.find(params[:id])
    @days = Day.where("talk_date >=?", Date.today).sort_by { |d| d.talk_date }
    if lightning_talk.update(lightning_talk_params)
      flash[:notice] = "You updated your lightning talk!"
      redirect_to root_path
    else
      @lightning_talk = lightning_talk
      flash[:notice] = "Something went wrong"
      render :edit
    end
  end

  private

  def lightning_talk_params
    params.require(:lightning_talk).permit(:name, :day_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
