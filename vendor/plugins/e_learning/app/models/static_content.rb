class StaticContent < ActiveRecord::Base
  belongs_to :course
  attr_accessible :course_id,:account_id,:content_type,:workflow_state,:page_desc
end
