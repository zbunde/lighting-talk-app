class LightningTalk < ActiveRecord::Base
  paginates_per 7

  validate :number_of_slots
  validates :name, :user_id, :day_id, presence: true

  belongs_to :user
  belongs_to :day
  belongs_to :talk_idea

  private

  def number_of_slots
    if self.day.number_of_slots <= 0
      self.errors[:base] << "Lightning talks for #{self.day.talk_date.readable_inspect} at max capacity"
    end
  end
end
