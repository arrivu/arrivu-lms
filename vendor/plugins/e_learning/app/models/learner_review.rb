class LearnerReview < ActiveRecord::Base
  attr_accessible :account_id,:user_id,:user_name,:message
  belongs_to :account
  validates_presence_of :user_name, :presence => true
  validates_presence_of :message, :presence => true
end
