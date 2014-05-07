class CoursePricing < ActiveRecord::Base
  attr_accessible :course_id,:end_at,:start_at,:account_id,:price
  belongs_to :course
  belongs_to :account
  validates_presence_of :course_id,:presence =>true
  validates_presence_of :account_id,:presence =>true
  validates_presence_of :end_at, :presence =>true
  validates_presence_of :start_at, :presence =>true
  validates_presence_of :price, :presence =>true, :numericality =>true
end