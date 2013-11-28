class CreateReferrals < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :referrals do |t|
      t.references :offer, :limit => 8
      t.references :pseudonym, :limit => 8
      t.text :email_subject
      t.text :email_text
      t.text :short_url_code
      t.timestamps
    end
  end

  def self.down
    drop_table :referrals
  end
end
