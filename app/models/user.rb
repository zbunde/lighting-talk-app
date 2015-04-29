class User < ActiveRecord::Base
  paginates_per 7
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_presence_of :email
  validates_presence_of :username
  has_many :lightning_talks
end
