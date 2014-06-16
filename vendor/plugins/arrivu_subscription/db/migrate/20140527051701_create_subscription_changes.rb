class CreateSubscriptionChanges < ActiveRecord::Migration
  tag :predeploy
  def self.up
    create_table :subscription_changes, :force => true do |t|
      t.column :subscribable_id, :integer, :null => false,:limit => 8
      t.column :subscribable_type, :string, :null => false
      t.column :original_subscription_plan_id, :integer, :null => true ,:limit => 8
      t.column :new_subscription_plan_id, :integer, :null => true,:limit => 8
      t.column :reason, :string, :null => false
      t.column :created_at, :timestamp, :null => false
    end
    add_index :subscription_changes, :reason
    add_index :subscription_changes, [:subscribable_id, :subscribable_type], :name => :on_subscribable_id_and_type
  end

  def self.down
    drop_table :subscription_changes
  end
end
