class CourseImage < ActiveRecord::Base
  attr_accessible :course_id,:account_id,:course_image_attachment_id,:course_back_ground_image_attachment_id
  belongs_to :course
  belongs_to :account
  validates_presence_of :course_id,:presence =>true
  validates_presence_of :account_id,:presence =>true
end
