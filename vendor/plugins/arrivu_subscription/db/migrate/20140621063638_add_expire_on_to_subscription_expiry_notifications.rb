class AddExpireOnToSubscriptionExpiryNotifications < ActiveRecord::Migration
  tag :predeploy
  def self.up
    add_column :subscription_expiry_notifications, :expire_on, :date
  end

  def self.down
    remove_column :subscription_expiry_notifications, :expire_on
  end
end
