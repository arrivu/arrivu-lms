Delayed::Periodic.cron 'SubscriptionValidator', '0 8 * * *' do

  # One week before
  @subscriptions = Subscription.where(:expire_on => Date.today+7.days)
  @subscriptions.each do |subscription|
  notification = SubscriptionExpiryNotification.find_by_subscription_id_and_notify_day_and_expire_on(subscription.id,7,
                                                                                                subscription.expire_on)
   unless notification
     notification = SubscriptionExpiryNotification.create(subscription_id: subscription.id,notify_day: 7,
                                                          expire_on: subscription.expire_on)
     puts "One week before expired subscription_id:#{subscription.id}"
     notification.notify_to_user!
   end

  end

  #A Day before
  @subscriptions = Subscription.where(:expire_on => Date.today+1.days)
  @subscriptions.each do |subscription|
  notification = SubscriptionExpiryNotification.find_by_subscription_id_and_notify_day_and_expire_on(subscription.id,1,
                                                                                                subscription.expire_on)
    unless notification
      notification = SubscriptionExpiryNotification.create(subscription_id: subscription.id,notify_day: 1,
                                                           expire_on: subscription.expire_on)
      puts "A Day before expired subscription_id:#{subscription.id}"
      notification.notify_to_user!
    end
  end

  #Downgrade and send email
  @subscriptions = Subscription.where("expire_on = ?", Date.today-Subscription::EXPIRATION_GRACE_PERIOD.days)
  @free_plan = Account.default.subscription_plans.free.first
  if @free_plan
  @subscriptions.each do |subscription|
  # degrade
   notification = SubscriptionExpiryNotification.find_by_subscription_id_and_notify_day_and_expire_on(subscription.id,0,
                                                                                                subscription.expire_on)
      unless notification
        subscription.update_attributes(subscription_plan_id: @free_plan.id)
        subscription.account.settings[:no_students] = @free_plan.feature_set.no_students
        subscription.account.settings[:no_teachers] = @free_plan.feature_set.no_teachers
        subscription.account.settings[:no_admins] = @free_plan.feature_set.no_admins
        subscription.account.settings[:no_courses] = @free_plan.feature_set.no_courses
        subscription.account.default_storage_quota_mb = @free_plan.feature_set.storage
        subscription.account.settings[:unlimited] = false unless @free_plan.feature_set.unlimited == 'true'
        subscription.account.save
        puts "Downgrade and send email subscription_id:#{subscription.id}"
        notification = SubscriptionExpiryNotification.create(subscription_id: subscription.id,notify_day: 0,
                                                             expire_on: subscription.expire_on)
        notification.notify_to_user!
        # Send mail
      end

    end
  end


end