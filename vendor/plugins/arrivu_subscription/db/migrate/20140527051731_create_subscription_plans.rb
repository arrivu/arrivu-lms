class CreateSubscriptionPlans < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :subscription_plans, :force => true do |t|
      t.column :account_id, :integer, :null => false ,:limit => 8
      t.column :name, :string, :null => false
      t.column :redemption_key, :string
      t.column :rate_cents, :integer, :null => false
      t.column :feature_set_id, :string, :null => false
    end
  end

  def self.down
    drop_table :subscription_plans
  end
end
