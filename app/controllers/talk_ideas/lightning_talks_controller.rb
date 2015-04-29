class TalkIdeas::LightningTalksController < ApplicationController
  before_action :set_talk_idea

  def new
    @lightning_talk = LightningTalk.new
    @days = Day.where("talk_date >=?", Date.today).sort_by { |d| d.talk_date}
  end

  def create
    lightning_talk = @talk_idea.lightning_talks.new(lightning_talk_params.merge(user_id: current_user.id))
    lightning_talk.name = @talk_idea.name
    lightning_talk, success = LightningTalkManager.build(lightning_talk)
    if success
      @talk_idea.destroy
      redirect_to root_path, notice: "Thanks for signing up for a lightning talk!"
    else
      @lightning_talk = lightning_talk
      @days = Day.where("talk_date >=?", Date.today).sort_by { |d| d.talk_date}
      flash[:notice] = "Something went wrong"
      render :new
    end
  end

  private

  def set_talk_idea
    @talk_idea = TalkIdea.find(params[:talk_idea_id])
  end

  def lightning_talk_params
      params.require(:lightning_talk).permit(:name, :day_id)
  end

end
