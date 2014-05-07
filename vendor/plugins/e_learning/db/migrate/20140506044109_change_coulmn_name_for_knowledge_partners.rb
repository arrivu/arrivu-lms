class ChangeCoulmnNameForKnowledgePartners < ActiveRecord::Migration
  tag :predeploy
  def self.up
    rename_column :knowledge_partners, :knowledge_partners_image_url, :knowledge_partners_attachment_id
  end

  def self.down
    rename_column :knowledge_partners, :knowledge_partners_attachment_id, :knowledge_partners_image_url
  end
end
