class CreateReferences < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :references do |t|
      t.references :referral, :limit => 8
      t.references :referral_provider, :limit => 8
      #t.numeric :referral_id, :limit => 8
      #t.numeric :provider_id, :limit => 8
      t.integer :visit_count
      t.text :short_url_code,  :unique => true
      t.text :provider
      t.text :status
      t.timestamps
    end
    add_index :references, :short_url_code, :unique => true
  end

  def self.down
    drop_table :references
  end


end
