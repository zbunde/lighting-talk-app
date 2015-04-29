class TalkIdea < ActiveRecord::Base
  validates :name, presence: true
  has_many :lightning_talks
end
