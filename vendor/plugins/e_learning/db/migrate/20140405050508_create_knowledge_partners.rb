class CreateKnowledgePartners < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :knowledge_partners do |t|
      t.integer :account_id, :limit => 8
      t.string :knowledge_partners_image_url
      t.string :partners_info
      t.timestamps
    end
  end

  def self.down
    drop_table :knowledge_partners
  end
end
