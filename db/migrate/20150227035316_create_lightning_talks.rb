class CreateLightningTalks < ActiveRecord::Migration
  def change
    create_table :lightning_talks do |t|
      t.belongs_to :user
      t.belongs_to :day
      t.string :name

      t.timestamps
    end
  end
end
