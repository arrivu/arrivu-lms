class CreateBillingTypes < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :billing_types do |t|
      t.belongs_to :account ,:limit => 8
      t.string :billing_type
      t.decimal :discount_percentage
      t.integer :months
      t.timestamps
    end
  end

  def self.down
    drop_table :billing_types
  end
end
