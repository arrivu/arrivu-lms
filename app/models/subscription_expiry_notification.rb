class SubscriptionExpiryNotification < ActiveRecord::Base
  attr_accessible :subscription_id ,:workflow_state ,:notify_day,:expire_on
  belongs_to :subscription

  after_save :broadcast_notifications


  def notify_to_user!
    @subscription_expiry_notification = true
    self.workflow_state = 'notified'
    self.save!
    @subscription_expiry_notification = false
  end

  has_a_broadcast_policy

  set_broadcast_policy do |p|
    p.dispatch :subscription_expiry_notification
    p.to {|record| record.subscription.payments.last.user}
    p.whenever { @subscription_expiry_notification}
  end

  def broadcast_notifications
    return if @broadcasted
    @broadcasted = true
    raise ArgumentError, "Broadcast Policy block not supplied for #{self.class.to_s}" unless self.class.broadcast_policy_list
    self.class.broadcast_policy_list.broadcast(self)
  end

end
