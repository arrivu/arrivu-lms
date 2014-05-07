class KnowledgePartner < ActiveRecord::Base
  attr_accessible :account_id,:knowledge_partners_attachment_id,:partners_info
  belongs_to :account
  validates_presence_of :knowledge_partners_attachment_id, :presence => true
  validates_presence_of :partners_info, :presence => true
end
