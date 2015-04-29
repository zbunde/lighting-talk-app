class AddTalkIdToLightningTalks < ActiveRecord::Migration
  def change
    add_column :lightning_talks, :talk_idea_id, :integer
  end
end
