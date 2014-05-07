class AccountSlider < ActiveRecord::Base
  belongs_to :account
  attr_accessible :account_id,:account_slider_attachment_id
end
