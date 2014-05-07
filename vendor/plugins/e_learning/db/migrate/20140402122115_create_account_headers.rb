class CreateAccountHeaders < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :account_headers do |t|
      t.integer :account_id, :limit => 8
      t.string :header_logo_url
      t.timestamps
     end
  end

  def self.down
    drop_table :account_headers
  end
end
