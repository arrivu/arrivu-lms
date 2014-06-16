class CreatePayments < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :payments do |t|
      t.belongs_to :account ,:limit => 8
      t.belongs_to :subscription ,:limit => 8
      t.belongs_to :subscription_plan ,:limit => 8
      t.belongs_to :billing_type ,:limit => 8
      t.belongs_to :user ,:limit => 8
      t.text :merchant_transaction_id
      t.decimal :transaction_amount
      t.string  :buyer_email_address, :transaction_type,:payment_method,:currency,:ui_mode,:hash_method,:bank_name
      t.boolean  :completed, :canceled, default: false
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
