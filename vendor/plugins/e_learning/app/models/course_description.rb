class CourseDescription < ActiveRecord::Base
  attr_accessible :course_id,:account_id,:short_description,:long_description
  belongs_to :course
  belongs_to :account
  validates_presence_of :course_id,:presence =>true
  validates_presence_of :account_id,:presence =>true
  validates_presence_of :short_description, :presence =>true
  validates_presence_of :long_description, :presence =>true

end
