class CreateReferrees < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :referrees do |t|
      t.email :email
      t.text :name
      t.integer :phone
      t.references :referral, :limit => 8
      t.references :coupon, :limit => 8
      t.text :status
      t.datetime :expiry_date

      t.email :referral_emails
      t.text :coupon_code
      t.timestamps
    end
  end

  def self.down
    drop_table :referrees
  end
end
